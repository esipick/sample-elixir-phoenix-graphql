defmodule GraphqlReact.Repo.Migrations.AlterUserEmailTable do
  use Ecto.Migration

  def change do
    rename table(:user_email), :email_1, to: :secondary_email
    alter table(:user_email) do
      add :email_no, :integer, default: 0
      remove :email_2
      remove :email_3
    end
  end
end
