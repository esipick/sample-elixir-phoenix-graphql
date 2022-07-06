defmodule GraphqlReact.Accounts.UserEmails do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias GraphqlReact.Repo
  require Logger


  alias GraphqlReact.Accounts.UserEmail


  # def get_email_by_id!(id), do: Repo.get!(UserEmail, id)
  def get_email(id) do
    Repo.get!(UserEmail, id)
  end
  def get_user_emails(user_id) do
    Repo.get_by(UserEmail, [user_id: user_id])
  end

  def add_email(attrs \\ %{}) do
    %UserEmail{}
    |> UserEmail.changeset(attrs)
    |> Repo.insert()
  end
  def update_email(email, attrs) do
    #attrs = Map.merge(attrs, %{user_id: current_user.id})
    Logger.info fn -> "attrs: #{inspect attrs}" end
    UserEmail.changeset(email, attrs)
     |> Repo.update()
  end

  def get_email_by_id(user_id) do
    Repo.get_by(UserEmail, [user_id: user_id])
  end
end
