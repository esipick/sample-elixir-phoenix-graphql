defmodule GraphqlReact.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlReact.Repo

  alias GraphqlReact.Accounts.User
  alias GraphqlReact.Accounts.Authentication
  alias GraphqlReact.Accounts.Encryption
  alias GraphqlReact.Accounts.PasswordReset
  alias GraphqlReact.Accounts.Setting
  alias GraphqlReact.Accounts.Settings
  alias GraphqlReact.Accounts.UserEmails
  alias GraphqlReact.Accounts.UserEmail
  alias GraphqlReact.Email
  alias GraphqlReact.Helpers

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]


  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs ) do

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> add_email_and_setting(attrs)

  end

  def add_email_and_setting(attrs, args) do

    case attrs do
      {:ok, user } ->

        case UserEmails.add_email(%{email: args.email,user_id: user.id, is_primary: true}) do
          {:ok, email} ->
            Settings.add_settings(%{ platform: args.platform,  user_id: user.id})
            send_email_verification(user, email)
          {:error, _error} ->
            {:error, "error while creating user"}
        end
        {:ok, user }
      {:error, _ } ->
        {:error , "something went wrong"}

    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def api_login(%{email: email, password: password, platform: platform}) do

    case get_user_by_email(email) do

      nil ->
        {:error, "user not found"}

        valid_email ->
          loaded_user =
            valid_email
            |> Repo.preload(:user)
            case  Settings.get_user_settings(loaded_user.user_id) do
              nil ->
                Settings.add_settings(%{ platform: platform, user_id: loaded_user.user_id })
              setting ->
                IO.inspect setting
                Settings.update_settings(setting, %{ platform: platform, user_id: loaded_user.user_id } )
            end

          cond do
            loaded_user.is_primary ->

              with {:ok, user} <- Encryption.validate_password(loaded_user.user, password),
                    {:ok, token, _} = Authentication.encode_and_sign(user,%{claim: "W08aAGGsKHoc0iIdF0Bp"}, token_type: "refresh", ttl: {Application.get_env(:graphql_react, :jwt_expiration_minutes), :minutes}) do
                  {:ok, %{:user => loaded_user, :token => token}}
              end
              loaded_user.is_primary == false ->
                {:error, ""}
          end
    end
  end

  def get_by_email(email) do
    Repo.get_by(User, [email: email])
  end

  def get_user_by_email(email) do
    UserEmails.get_email(email)
  end


  def check_user(email) do
    user = get_by_email(email)

    cond do

      user ->
        {:ok, reset} = create_password_reset(user)

        reset
        |> Repo.preload(:user)
        |> Email.reset_password_email()
        |> GraphqlReact.Mailer.deliver_later

        {:ok, "Please check your email for password reset instructions."}

      user == nil ->
        {:error, "This email is not registered"}
    end
  end

  def create_password_reset(user) do
    case delete_all_existing_user_codes(user.id) do
      nil->
        password_reset_code(user)
      codes->
       password_reset_code(user)
    end
 end

def delete_all_existing_user_codes(user_id) do
    from(p in PasswordReset, where: p.user_id == ^user_id) |> Repo.delete_all
end

def password_reset_code(user) do
    %PasswordReset{}
    |> PasswordReset.changeset(%{user_id: user.id, code: Helpers.hex(5)})
    |> Repo.insert()
  end

def reset_password(attrs) do
    case get_reset_code(attrs.code) do
      nil->
        {:error, "Code does not exist"}
      code->
        case update_user(code.user , %{password: attrs.password, password_confirmation: attrs.password_confirmation}) do
          nil->
            {:error, "Unable to reset password"}
          user->
            delete_all_existing_user_codes(code.user_id)
            {:ok, "Password has been reset"}
        end
    end
  end

  def get_reset_code(code) do
    Repo.get_by(PasswordReset, code: code)
    |> Repo.preload([:user])
  end

  def sendMail(result) do
    name = "#{result.first_name} #{result.last_name}"
    Email.send_marketing_email(result.email,name)
  end


  def update_email(user , args) do

    email = UserEmails.get_primary_email(user.id)

    cond do
      args.email == email.email ->
        {:error, "new email is same as old email"}

      true ->
        change_attr = %{
          email: args.email,
          is_verified: false,
          is_primary: true
        }
        case UserEmails.update_email(email,change_attr ) do
          nil ->
            {:error, "failed to update primary email"}

          {:ok , email } ->
            send_email_verification_mail(email,user)
        end

    end

  end

  def send_email_verification(curr_user, u_email) do

    {:ok , code } = get_email_verification_code(curr_user)

    url = Helpers.get_client_url(curr_user, "/email-verification") <> "/#{u_email.id}" <> "/#{code.code}"
    Email.email_verification(u_email.email, url)
    |> GraphqlReact.Mailer.deliver_later
  end

  def get_email_verification_code(user) do
    case delete_all_existing_user_codes(user.id) do
      nil->
       %PasswordReset{}
        |> PasswordReset.changeset(%{user_id: user.id, code: Helpers.hex(16)})
        |> Repo.insert()
      _codes->
      %PasswordReset{}
        |> PasswordReset.changeset(%{user_id: user.id, code: Helpers.hex(16)})
        |> Repo.insert()
    end
  end

  def verfiy_email_code(attr) do
    case get_reset_code(attr.code) do

      nil->

        {:error, "invalid code or link has expired"}

      code ->

        delete_all_existing_user_codes(code.user_id)

        update_email_verified(attr.email_id)

      {:ok,  "email verified succesfully"}

    end
  end

  def update_email_verified(email_id) do

    email  = UserEmails.get_email_by_email_id(email_id)

    change_attrs = %{
      is_verified: true,
    }

    UserEmails.update_email(email ,change_attrs )

  end

  def update_password(args, curr_user) do
    case Encryption.validate_password(curr_user, args.old_password) do
      {:ok, user} ->
        case update_user(user , %{password: args.new_password, password_confirmation: args.confirm_new_password}) do
          nil->
            {:error, "Unable to reset password"}
          user->
            {:ok, "Password has been updated succesfully"}
        end
      {:error, _error } ->
        {:error, "old password is incorrect"}
    end

  end

  def get_user_emails(user) do
    emails = UserEmails.get_all_emails(user.id)

    {:ok , %{user_emails: emails }}
  end



  def send_email_verification_mail(email, user) do
    {:ok , code } = get_email_verification_code(user)

    url = Helpers.get_client_url(user, "/email-verification") <> "/#{email.id}" <> "/#{code.code}"
    email = Email.update_email(email.email, url)
    |> GraphqlReact.Mailer.deliver_later
    case email do
      nil ->
        {:ok , "Error while sending verification email"}
      bambo ->
        {:ok, "Email Updated Succesfully, Please check your mail for verification"}
    end



  end

end
