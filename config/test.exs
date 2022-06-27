import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :graphql_react, GraphqlReact.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "graphql_react_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_react_web, GraphqlReactWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QC35EPEaDzXwBlIGWpMeulKBEU+BX1juX4ci0Ypr316Q5w2E6dJdkBngnx81trI0",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :graphql_react, GraphqlReact.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :graphql_react, :jwt_expiration_minutes, String.to_integer(System.get_env("JWT_EXPIRATION_MINUTES") || "2045555666")
