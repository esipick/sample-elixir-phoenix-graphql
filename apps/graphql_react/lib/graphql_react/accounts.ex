defmodule GraphqlReact.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GraphqlReact.Repo

  alias GraphqlReact.Accounts.User
  alias GraphqlReact.Accounts.Authentication
  alias GraphqlReact.Accounts.Encryption
  alias GraphqlReact.Email

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]


  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def api_login(%{email: email, password: password}) do
    case get_user_by_email(email) do
        nil ->
            {:error, "email not found"}
        user ->
            with {:ok, user} <- Encryption.validate_password(user, password),
                    {:ok, token, _} = Authentication.encode_and_sign(user,%{claim: "W08aAGGsKHoc0iIdF0Bp"}, token_type: "refresh", ttl: {Application.get_env(:graphql_react, :jwt_expiration_minutes), :minutes}) do

                {:ok, %{:user => user, :token => token}}
            end
    end
  end

  def get_by_email(email) do
    Repo.get_by(User, [email: email])
  end
  def get_user_by_email(email) when is_nil(email) or email == "", do: nil

  def get_user_by_email(email) do
    Repo.get_by(User, [email: email])
  end


  def sendMail(result) do
    name = "#{result.first_name} #{result.last_name}"
    Email.send_marketing_email(result.email,name)
  end

end
