defmodule GraphqlReact.Repo.Migrations.AlterUserEmailField do
  use Ecto.Migration

  def change do
    create(unique_index(:user_email, [:email_1]))
    create(unique_index(:user_email, [:email_2]))
    create(unique_index(:user_email, [:email_3]))
  end
end
