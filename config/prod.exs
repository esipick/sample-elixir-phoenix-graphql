import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
# config :graphql_react_web, GraphqlReactWeb.Endpoint,
#   url: [host: "example.com", port: 80],
#   cache_static_manifest: "priv/static/cache_manifest.json"

config :graphql_react_web, GraphqlReactWeb.Endpoint,
      load_from_system_env: true,
      url: [scheme: "https:", host: "sample-elixir-phoenix-graphql.herokuapp.com", port: 443],
      force_ssl: [rewrite_on: [:x_forwarded_proto]],
      # cache_static_manifest: "priv/static/cache_manifest.json",
      secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :graphql_react_web, GraphqlReact.Repo,
       url: System.get_env("DATABASE_URL"),
       pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
       ssl: true



config :graphql_react, GraphqlReact.Mailer,
      adapter: Bamboo.SendGridAdapter,
      api_key: System.get_env("SENDGRID_API_KEY")

config :graphql_react, :jwt_expiration_minutes, String.to_integer(System.get_env("JWT_EXPIRATION_MINUTES") || "2045555666")


config :graphql_react, :website_url, System.get_env("WEBSITE_URL") || "http://localhost:4000/email-verification"
config :graphql_react, :react_url, System.get_env("REACT_URL") || "http://localhost:3000/email-verification"
config :graphql_react, :angular_url, System.get_env("ANGULAR_URL") || "http://localhost:4200/email-verification"


# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :graphql_react_web, GraphqlReactWeb.Endpoint,
#       ...,
#       url: [host: "example.com", port: 443],
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :graphql_react_web, GraphqlReactWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# Do not print debug messages in production
config :logger, level: :info
