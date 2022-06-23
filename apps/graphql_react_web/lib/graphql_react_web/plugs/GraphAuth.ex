defmodule GraphqlReact.Plugs.GraphAuth do
  @behaviour Plug

  require Logger

  import Plug.Conn

  # alias GraphqlReact.{Repo, User}
  alias GraphqlReact.Accounts.Authentication

  def init(opts), do: opts

  def call(conn, _) do
      context = build_context(conn)
      Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
      with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user, claims} <- authorize(token) do
          if current_user != nil do
              context = %{current_user: current_user}
              get_originator(conn, context)
          else
              %{}
          end
      else
          _ -> %{}
      end
  end

  def get_originator(conn, context) do
      if get_req_header(conn, "originator") |> Enum.count() === 1 do
          [originator] = get_req_header(conn, "originator");
          Map.put(context, :originator, originator)
      else
          Map.put(context, :originator, "not available")
      end
  end
  defp authorize(token) do
      Authentication.resource_from_token(token)
  end
end
