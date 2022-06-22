defmodule Grapgql.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Grapgql.Accounts.{Encryption}

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :encrypted_password, :string
    field :username, :string

    # Virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :first_name, :last_name])
    |> validate_required([:username, :email,:first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
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
