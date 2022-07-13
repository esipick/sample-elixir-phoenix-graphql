defmodule GraphqlReact.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias GraphqlReact.Accounts.{Encryption}
  alias GraphqlReact.Accounts.UserEmail

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :encrypted_password, :string
    field :username, :string

    # Virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many(:user_email, UserEmail)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :first_name, :last_name])
    |> validate_required([:username, :first_name, :last_name])
    |> validate_confirmation(:password)
    |> encrypt_password
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)
    if password do
        encrypted_password = Encryption.hash_password(password)
        put_change(changeset, :encrypted_password, encrypted_password)
    else
        changeset
    end
  end

end
