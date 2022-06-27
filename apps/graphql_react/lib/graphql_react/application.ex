defmodule GraphqlReact.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GraphqlReact.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GraphqlReact.PubSub}
      # Start a worker by calling: GraphqlReact.Worker.start_link(arg)
      # {GraphqlReact.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GraphqlReact.Supervisor)
  end
end
