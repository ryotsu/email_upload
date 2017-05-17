defmodule Webserver.AccountTest do
  use Webserver.DataCase

  alias Webserver.Account

  describe "users" do
    alias Webserver.Account.User

    @valid_attrs %{dropbox_token: "some dropbox_token", dropbox_uid: "some dropbox_uid", firstname: "some firstname", lastname: "some lastname", namespace: "some namespace"}
    @update_attrs %{dropbox_token: "some updated dropbox_token", dropbox_uid: "some updated dropbox_uid", firstname: "some updated firstname", lastname: "some updated lastname", namespace: "some updated namespace"}
    @invalid_attrs %{dropbox_token: nil, dropbox_uid: nil, firstname: nil, lastname: nil, namespace: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.dropbox_token == "some dropbox_token"
      assert user.dropbox_uid == "some dropbox_uid"
      assert user.firstname == "some firstname"
      assert user.lastname == "some lastname"
      assert user.namespace == "some namespace"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.dropbox_token == "some updated dropbox_token"
      assert user.dropbox_uid == "some updated dropbox_uid"
      assert user.firstname == "some updated firstname"
      assert user.lastname == "some updated lastname"
      assert user.namespace == "some updated namespace"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
