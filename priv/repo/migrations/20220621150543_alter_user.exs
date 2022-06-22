defmodule Grapgql.Repo.Migrations.AlterUser do
  use Ecto.Migration

  def change do
    rename table(:users), :firstName, to: :first_name
    rename table(:users), :lastName, to: :last_name
  end
end
