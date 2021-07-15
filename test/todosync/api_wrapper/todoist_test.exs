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

    test "#update/2" do
      @client |> Todoist.update(%{id: 3636243955, content: "Old Content"})

      found = @client |> Todoist.find(3636243955)

      @client |> Todoist.update(%{id: 3636243955, content: "Update Content"})
      updated = @client |> Todoist.find(3636243955)

      assert found.body["content"] != updated.body["content"]
      assert updated.body["content"] == "Update Content"
    end

  end
end
