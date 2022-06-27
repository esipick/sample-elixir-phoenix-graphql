defmodule GraphqlReact.AccountsTest do
  use GraphqlReact.DataCase

  alias GraphqlReact.Accounts

  describe "users" do
    alias GraphqlReact.Accounts.User

    # import GraphqlReact.AccountsFixtures
    @valid_attrs %{username: "tim",first_name: "tim", last_name: "mon", email: "tim@liv.com", password: "123456", encrypted_password: "123456"}
    @update_attrs %{email: "tim@live.com"}
    @invalid_attrs %{username: nil, email: "tim",  password: nil ,first_name: nil, last_name: nil }
    @invalid_email %{username: "tim",  email: "tim", password: "123456", encrypted_password: "123456"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()
    user
  end

  test "list_users/0 returns all users" do
    user = user_fixture()
    Map.put(user, :password, nil)
    db_users = Accounts.list_users()
    assert List.first(db_users).id == user.id
  end



    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert user.email == "tim@liv.com"
      assert user.username == "tim"
      assert user.first_name == "tim"
      assert user.last_name == "mon"
      db_user = Accounts.get_user!(user.id)
      assert db_user.id == user.id
      assert db_user.username == user.username
      assert db_user.email == user.email
      assert db_user.first_name == "tim"
      assert db_user.last_name == "mon"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{email: email}} = Accounts.create_user(@valid_attrs)
      assert email == @valid_attrs.email
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with invalid email returns error changeset" do
      assert {:error, _changeset} = Accounts.create_user(@invalid_email)
    end

    test "create_user/1 with duplicate email returns error changeset" do
      assert {:ok, %User{} = _user} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      {:ok, %User{} = updated_user} = Accounts.update_user(user, @update_attrs)
      assert updated_user.email == @update_attrs.email
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user.email == Accounts.get_user!(user.id).email
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "api_login/1 returns the user" do
      user = user_fixture()
      assert {:ok, %{:token => _token}} = Accounts.api_login(%{email: user.email, password: user.password})
  end

  test "api_login/1 with invalid data returns nil" do
      assert {:error, _message} = Accounts.api_login(%{email: "abc", password: "123"})
  end

  test "api_login/1 with invalid password returns nil" do
      user_fixture()
      assert {:error, _message} = Accounts.api_login(%{email: "tim@liv.com", password: "123"})
  end

  end
end
