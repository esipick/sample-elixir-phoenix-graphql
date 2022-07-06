defmodule GraphqlReact.Repo.Migrations.AddFieldsToUserEmails do
  use Ecto.Migration

  def change do
    alter table(:user_email) do
      add :isVerified, :boolean, default: false
      add :isPrimary, :boolean, default: false

    end
  end
end
