defmodule GraphqlReact.Repo.Migrations.ChangeUserEmailFieldsName do
  use Ecto.Migration

  def change do
    rename table(:user_email), :isVerified, to: :is_verified
    rename table(:user_email), :isPrimary, to: :is_primary
  end
end
