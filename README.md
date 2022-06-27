# GraphqlReact.Umbrella
Elixir Phoneix Grapgql example app

Dev env setup


Install elixir


Install elixir  via asdf


Installation via asdf 

https://asdf-vm.com/guide/getting-started.html#_2-download-asdf

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0

Add the following to ~/.bashrc:

  . $HOME/.asdf/asdf.sh

install plugins

1. asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

2. asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git


Install dependencies and run setup


Install elixir dependencies
mix deps.get
mix deps.compile

Setup database
mix ecto.setup

Bootstra  user on a new server
mix run priv/repo/seeds.exs # is also running automatically with mix ecto.setup

Run server
mix phx.server

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


  # deployment on Heroku 
  add follwong build packs
  
  https://github.com/HashNuke/heroku-buildpack-elixir.git
  https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
  https://github.com/heymackey/heroku-phoenix-umbrella-static-buildpack
  