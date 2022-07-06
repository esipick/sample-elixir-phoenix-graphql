defmodule GraphqlReact.Accounts.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_settings" do
    field :email_verified, :boolean
    field :platform, :string

    belongs_to(:user, GraphqlReact.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:email_verified, :platform, :user_id])
  end

end
