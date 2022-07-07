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
          {:ok, _email} ->
            Settings.add_settings(%{ platform: args.platform,  user_id: user.id})

          {:error, _error} ->
            {:error, "error while creating user"}
        end
    user
        |> Repo.preload(:user_email)
        |> send_email_verification

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

  def api_login(%{email: email, password: password}) do

    case get_user_by_email(email) do

      nil ->
        {:error, "user not found"}

        valid_email ->
          loaded_user =
            valid_email
            |> Repo.preload(:user)

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

    IO.inspect email
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
            IO.inspect "email updated "
            IO.inspect email
            send_email_verification_mail(args.email,user,"/settings-update-email")
        end

    end

  end

  def send_email_verification(curr_user) do
    user =
      curr_user
      |> Repo.preload(:user_email)

    email =  Enum.fetch!(user.user_email,0).email

    {:ok , code } = get_email_verification_code(user)

    url = Helpers.get_client_url(user, "/email-verification") <> "/#{user.id}" <> "/#{code.code}"

    Email.email_verification(email, url)
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

      code->

        delete_all_existing_user_codes(code.user_id)

        update_email_verified(code.user_id,true)

      {:ok,  "email verified succesfully"}

    end
  end

  def update_email_verified(userID,isVerified) do
    setting_attrs = %{
      email_verified: isVerified,
      user_id: userID
    }
    Settings.get_settings_by_id(userID)
    |> Settings.update_settings(setting_attrs)
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

  def add_email(args, curr_user) do

    {:ok , user_emails } = get_user_emails(curr_user)

    email_list = user_emails.user_emails
      |> Enum.filter(fn(value) -> value.secondary_email == args.email end)
      |> Enum.map(fn(filtered_value) -> filtered_value  end)

    cond do
      args.email == curr_user.email ->
        {:error, "this email is already exisits in your account"}

      length(user_emails.user_emails) == 3 ->
        {:error, "you can add upto 3 emails only !"}
      length(email_list) > 0 ->
        {:error, "This email is already added !"}
      true ->
        email_length =  cond do
          length(user_emails.user_emails) == 0 ->
            1
          length(user_emails.user_emails) == 1 ->
            2
          length(user_emails.user_emails) == 2 ->
            3
        end
        {:ok , code } = get_email_verification_code(curr_user)
        new_email = %{
          secondary_email: args.email,
          email_no:  email_length,
          is_verified: false,
          is_primary: false,
          user_id: curr_user.id
        }

        case UserEmails.add_email(new_email) do
          {:ok, email} ->
            {:ok , code } = get_email_verification_code(curr_user)
            url = Helpers.get_client_url(curr_user, "/settings-add-email") <> "/#{code.code}" <> "/#{email.id}"
            IO.inspect url
            code
            |> Repo.preload(:user)
            |> Email.update_email(args.email, url)
            |> GraphqlReact.Mailer.deliver_later
            {:ok, "Email added, please verfiy your new email"}
          {:error, _} ->
            {:error, "Failed to add the email"}
        end
      end
  end

  def send_email_verification_mail(email, user, path) do

    {:ok , code } = get_email_verification_code(user)

    url = Helpers.get_client_url(user, path) <> "/#{code.code}"
    IO.inspect url
    code
    |> Repo.preload(:user)
    |> Email.update_email(email, url)
    |> GraphqlReact.Mailer.deliver_later

  end

end
