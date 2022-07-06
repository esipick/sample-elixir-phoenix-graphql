defmodule GraphqlReact.Accounts.UserEmail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_email" do
    field :secondary_email, :string
    field :email_no, :integer
    field :is_verified, :boolean
    field :is_primary, :boolean

    belongs_to(:user, GraphqlReact.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:secondary_email, :email_no,:is_verified,:is_primary, :user_id])
    |> validate_format(:secondary_email, ~r/@/)

  end


end
