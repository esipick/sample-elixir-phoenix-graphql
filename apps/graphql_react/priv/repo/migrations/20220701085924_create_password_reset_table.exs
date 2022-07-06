defmodule GraphqlReact.Repo.Migrations.CreatePasswordResetTable do
  use Ecto.Migration

  def change do
    create table(:password_resets) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:code, :string)
      timestamps()
    end

    create(index(:password_resets, [:user_id]))
  end
end
