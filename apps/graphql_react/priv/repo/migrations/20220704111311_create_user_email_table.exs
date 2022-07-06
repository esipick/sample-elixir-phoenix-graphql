defmodule GraphqlReact.Repo.Migrations.CreateUserEmailTable do
  use Ecto.Migration

  def change do
    create table(:user_email) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:email_1, :string)
      add(:email_2, :string)
      add(:email_3, :string)
      timestamps()
    end

    create(index(:user_email, [:user_id]))
  end
end
