defmodule GraphqlReact.Repo.Migrations.RemoveEmailNoUserEmail do
  use Ecto.Migration

  def change do
    alter table(:user_email) do
      remove :email_no
    end
  end
end
