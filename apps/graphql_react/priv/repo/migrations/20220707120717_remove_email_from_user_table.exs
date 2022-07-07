defmodule GraphqlReact.Repo.Migrations.RemoveEmailFromUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :email
    end
    alter table(:user_settings) do
      remove :email_verified
      remove :is_primary
    end
  end
end
