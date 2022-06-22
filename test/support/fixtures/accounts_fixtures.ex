defmodule Grapgql.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Grapgql.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        firstName: "some firstName",
        lastName: "some lastName",
        password: "some password",
        username: "some username"
      })
      |> Grapgql.Accounts.create_user()

    user
  end
end
