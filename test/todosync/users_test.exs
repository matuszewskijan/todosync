defmodule Todosync.UserTest do
  use Todosync.DataCase

  describe "Users" do
    alias Todosync.Users

    test "#create/2" do
      user = Users.create("api_key")
      assert user.auth_key != nil
    end

    test "#find_by_service/2" do
      user = Users.create("api_key")

      assert Users.find_by_service("todoist", user.todoist_key) != nil

      assert_raise RuntimeError, fn ->
       assert Users.find_by_service("other", user.todoist_key) == "Not Implemented"
      end
    end

    test "#find_by_auth_key/1" do
      user = Users.create("api_key")

      assert Users.find_by_auth_key(user.auth_key) != nil
    end

    test "#find_by_todoist_key/1" do
      user = Users.create("api_key")

      assert Users.find_by_todoist_key(user.todoist_key) != nil
    end

  end
end
