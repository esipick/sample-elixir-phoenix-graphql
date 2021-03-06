defmodule GraphqlReactWeb.GraphQL.Accounts.AccountsResolvers do
  alias GraphqlReact.Accounts
  alias GraphqlReact.Accounts.AccountMails
  use GraphqlReactWeb.GraphQL.Errors
  alias GraphqlReact.Helpers
  alias GraphqlReactWeb.GraphQL.EctoHelpers
  alias GraphqlReact.Repo
  alias GraphqlReact.Accounts.UserEmails

  def create_user(_parent, args, _context) do
     case Accounts.create_user(args.input) do
      {:ok, result} ->
        # Accounts.sendMail(result)
        {:ok, result}
      {:error, _error, error, %{}} ->
        {:error, error}
     end
  end
    def login(_parent, %{email: email, password: password, platform: platform} = _params, _context) do
      case Accounts.api_login(%{email: email, password: password, platform: platform}) do
          {:ok, res} ->
              {:ok, res}
          _ ->
              @invalid_login
      end
  end

  def get_current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    case Accounts.get_user!(current_user.id) do
        nil ->
            @not_found
        user ->
          resp = %{
            id: user.id,
            username: user.username,
            first_name: user.first_name,
            last_name: user.last_name,
            email: UserEmails.get_primary_email(user.id).email,

          }
          {:ok, resp}
    end
  end
  def get_current_user(_parent, _args, _context), do: @not_authenticated


  def forgot_submit(_parent, %{email: email} = _params, _context) do
      email = String.trim(email)
      cond do
        email == "" ->
          {:error, "Please enter your email"}

        String.match?(email, Helpers.email_regex()) ->
          GraphqlReact.Accounts.check_user(email)
        true ->
            {:error, "Invalid email format"}
      end
  end

  def reset_password(_parent, args, _context) do
    EctoHelpers.action_wrapped(fn ->
        Accounts.reset_password(args)
    end)
end

  def update_email(_parent, args, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      current_user
      |> Repo.preload(:user_email)
      |> Accounts.update_email(args)
  end)
  end
  def update_email(_parent, _args, _context), do: @not_authenticated


  def verify_email(_parent, args, _context) do
    EctoHelpers.action_wrapped(fn ->
      Accounts.verfiy_email_code(args)
  end)
  end

  def update_password(_parent, args, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      Accounts.update_password(args , current_user)
  end)
  end

  def update_password(_parent, _args, _context), do: @not_authenticated

  def add_new_email(_parent, args, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      AccountMails.add_secondary_email(args , current_user)
  end)
  end

  def add_new_email(_parent, _args, _context), do: @not_authenticated

  def get_user_emails(_parent, args, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      Accounts.get_user_emails(current_user)
  end)
  end

  def get_user_emails(_parent, _args, _context), do: @not_authenticated


  def verify_secondary_email(_parent, args, _context) do
    EctoHelpers.action_wrapped(fn ->
      AccountMails.verify_secondary_email(args)
  end)
  end

  def delete_email(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      AccountMails.delete_email(id)
  end)
  end
  def delete_email(_parent, _args, _context), do: @not_authenticated

  def set_primary_email(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    EctoHelpers.action_wrapped(fn ->
      AccountMails.set_primary_email(id ,current_user)
  end)
  end
  def set_primary_email(_parent, _args, _context), do: @not_authenticated







end
