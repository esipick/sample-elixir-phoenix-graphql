defmodule GraphqlReact.Repo.Migrations.AddUserSettings do
  use Ecto.Migration

  def change do
    create table(:user_settings) do
      add :email_verified, :boolean
      add :platform, :string

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
