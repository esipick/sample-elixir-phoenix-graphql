defmodule GrapgqlWeb.GraphQL.Accounts.AccountsResolvers do
  alias Grapgql.Accounts
  use GrapgqlWeb.GraphQL.Errors


  def create_user(_parent, args, _context) do
    IO.inspect args
     case Accounts.create_user(args.input) do
      {:ok, result} ->
        {:ok, result}
      {:error, _error, error, %{}} ->
        {:error, error}
     end
  end
    def login(_parent, %{email: email, password: password} = _params, _context) do
      case Accounts.api_login(%{email: email, password: password}) do
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
            {:ok, user}
    end
end
def get_current_user(_parent, _args, _context), do: @not_authenticated

end
