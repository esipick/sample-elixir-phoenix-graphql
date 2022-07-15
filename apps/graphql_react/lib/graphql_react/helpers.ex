defmodule GraphqlReact.Helpers do
  @moduledoc """
  Helper functions
  """
  alias GraphqlReact.Accounts.Settings
  require Logger
  @doc """
  Generate a url safe random string
  """
  def email_regex do
      ~r/^[a-z0-9](\.?[\w.!#$%&’*+\-\/=?\^`{|}~]){0,}@[a-z0-9-]+\.([a-z]{1,6}\.)?[a-z]{2,6}$/i
    #    ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@([a-zA-Z0-9-]+)\.([a-zA-Z0-9-]+)*$/i
  end

  @hex_values ["a", "b", "c", "d", "e", "f", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
  def hex(length) do
      Enum.reduce(0..(length - 1), "", fn _, acc -> acc <> Enum.random(@hex_values) end)
  end


  def get_client_url(user, path) do
    settings = Settings.get_user_settings(user.id)

    url =  cond do
      settings.platform == "ELIXIR_REACT" ->
        Application.get_env(:graphql_react, :website_url) <> path

        settings.platform == "REACT" ->
         Application.get_env(:graphql_react, :react_url) <> path

         settings.platform == "ANGULAR" ->
        Application.get_env(:graphql_react, :angular_url) <> path
    end
    url
  end

end
