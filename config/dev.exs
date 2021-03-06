import Config

# Configure your database
config :graphql_react, GraphqlReact.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "graphql_react_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :graphql_react_web, GraphqlReactWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "CQQjan0pd/3YCPjzJLByCcyYzdfpkyFc1rNXopEqEZAgaNUKtWyAIqCrLgS8SklX",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :graphql_react_web, GraphqlReactWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/graphql_react_web/(live|views)/.*(ex)$",
      ~r"lib/graphql_react_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

config :graphql_react, GraphqlReact.Mailer,
       adapter: Bamboo.SendGridAdapter,
       api_key: ""

config :graphql_react, :jwt_expiration_minutes, String.to_integer(System.get_env("JWT_EXPIRATION_MINUTES") || "2045555666")

config :graphql_react, :website_url, System.get_env("WEBSITE_URL") || "http://localhost:4000"
config :graphql_react, :react_url, System.get_env("REACT_URL") || "http://localhost:3000"
config :graphql_react, :angular_url, System.get_env("ANGULAR_URL") || "http://localhost:4200"

config :graphql_react, :registration_email_confirmation_template, System.get_env("EMAIL_CONFIRMATION_TEMP_ID")
config :graphql_react, :from_email, System.get_env("FROM_EMAIL") || "kashan.ghori@esipick.com"
config :graphql_react, :from_email_name, System.get_env("FROM_EMAIL_NAME") || "Esipick"
config :graphql_react, :reset_password_email_template_id, System.get_env("RESET_PASSWORD_EMAIL_TEMPLATE_ID")
config :graphql_react, :update_user_settings_id, System.get_env("UPDATE_USER_SETTINGS")
config :graphql_react, :email_verification_id, System.get_env("EMAIL_VERIFICATION")
config :graphql_react, :change_email_temp_id, System.get_env("CHANGE_EMAIL_TEMP_ID")
