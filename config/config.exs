# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :graphql_react,
  ecto_repos: [GraphqlReact.Repo]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :graphql_react, GraphqlReact.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :graphql_react_web,
  ecto_repos: [GraphqlReact.Repo],
  generators: [context_app: :graphql_react]

# Configures the endpoint
config :graphql_react_web, GraphqlReactWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GraphqlReactWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: GraphqlReact.PubSub,
  live_view: [signing_salt: "XQ4hkq/z"],
  secret_key_base: "fJ+knje6IywkEnYUYFWmqY0pmq1/FpmLPqzJshRoJS8R0VDHMhm7A0Fq9JugB34a"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --loader:.js=jsx --outdir=../priv/static/assets --external:/fonts/* --external:/images/* ),
    cd: Path.expand("../apps/graphql_react_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}

  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :graphql_react, GraphqlReact.Accounts.Authentication,
    issuer: "graphql_react",
    secret_key: "T/3suPhFSi/AJl3tdo/eiNYZO9bk0+jFMYIumrpTU6WdmKro2MxcIMl0hYKwEmIK"
