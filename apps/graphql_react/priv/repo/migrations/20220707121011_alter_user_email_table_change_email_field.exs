defmodule GraphqlReact.Repo.Migrations.AlterUserEmailTableChangeEmailField do
  use Ecto.Migration

  def change do
    rename table(:user_email), :secondary_email, to: :email
  end
end
