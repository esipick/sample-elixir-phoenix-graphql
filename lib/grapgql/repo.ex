defmodule Grapgql.Repo do
  use Ecto.Repo,
    otp_app: :grapgql,
    adapter: Ecto.Adapters.Postgres
end
