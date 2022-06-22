defmodule Grapgql.Repo.Migrations.ChangePassField do
  use Ecto.Migration

  def change do
    rename table(:users), :password, to: :encrypted_password
  end
end
