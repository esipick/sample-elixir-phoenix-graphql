defmodule GraphqlReact.Accounts.PasswordReset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "password_resets" do
    field :code, :string

    belongs_to(:user, GraphqlReact.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:code, :user_id])
    |> validate_required([:code, :user_id])
  end

end
