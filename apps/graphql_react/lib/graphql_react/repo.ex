defmodule GraphqlReact.Repo do
  use Ecto.Repo,
    otp_app: :graphql_react,
    adapter: Ecto.Adapters.Postgres
end
