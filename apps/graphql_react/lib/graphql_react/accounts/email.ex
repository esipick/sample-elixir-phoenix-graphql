defmodule GraphqlReact.Accounts.UserEmail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_email" do
    field :email, :string
    field :is_verified, :boolean
    field :is_primary, :boolean

    belongs_to(:user, GraphqlReact.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_verified, :is_primary, :user_id])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "already exist")
  end


end
