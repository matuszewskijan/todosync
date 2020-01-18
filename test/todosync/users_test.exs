defmodule Todosync.FearAndGreedTest do
  use Todosync.DataCase

  describe "Users" do
    alias Todosync.Users

    @one_day 86400
    @valid_attrs1 %{todoist_key: "key", value_classification: "greed", timestamp: "#{@one_day}"}
    @valid_attrs2 %{value: "0", value_classification: "fear", timestamp: "#{@one_day * 2}"}
    @invalid_attrs %{value: nil, value_classification: "superb", timestamp: "1573577402"}

    test "#create/1" do
      user = Users.create("api_key")
      assert user.auth_key != nil
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
