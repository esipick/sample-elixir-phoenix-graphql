defmodule GraphqlReact.Accounts.Settings do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias GraphqlReact.Repo
  require Logger


  alias GraphqlReact.Accounts.User
  alias GraphqlReact.Accounts.Setting


  def get_user_settings(user_id) do
    Repo.get_by(Setting, [user_id: user_id])
  end

  def add_settings(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end
  def update_settings(setting, attrs) do
    #attrs = Map.merge(attrs, %{user_id: current_user.id})
    Logger.info fn -> "attrs: #{inspect attrs}" end
      Setting.changeset(setting, attrs)
     |> Repo.update()
  end

  def get_settings_by_id(user_id) do
    Repo.get_by(Setting, [user_id: user_id])
  end
end
