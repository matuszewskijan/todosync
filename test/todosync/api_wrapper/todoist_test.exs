defmodule Todosync.ApiWrapper.TodoistTest do
  use Todosync.DataCase

  describe "Users" do
    alias Todosync.ApiWrapper.Todoist

    @client Todoist.client(Application.get_env(:todosync, :api_key))

    test "#list/1" do
      tasks = @client
      |> Todoist.list

      assert Enum.count(tasks.body) > 0
    end

    test "#find/2" do
      task = @client
      |> Todoist.find(3636243955)

      assert task.body["id"] == 3636243955
    end

    # test "#create/1" do
    #   created = @client
    #   |> Todoist.create(%{content: "Test Task"})
    #   assert user.auth_key != nil
    # end

    test "#update/3" do
      @client |> Todoist.update(3636243955, %{content: "Old Content"})

      found = @client |> Todoist.find(3636243955)

      updated = @client
      |> Todoist.update(3636243955, %{content: "Update Content"})

      assert found.body["content"] != updated.body["content"]
      assert updated.body["content"] == "Update Content"
    end

  end
end
