# Elixir Phoneix Grapgql example app 

# Dev env setup

1. Install elixir 

3. Install dependencies and run setup
# Install elixir dependencies
mix deps.get
mix deps.compile


# Setup database
mix ecto.setup

## Bootstra  user on a new server

```bash
mix run priv/repo/seeds.exs # is also running automatically with mix ecto.setup
```

# Run server
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# to visit graphql playground Visit

 [`localhost:4000`](http://localhost:4000/api/graphiql)

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
