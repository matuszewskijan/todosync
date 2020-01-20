defmodule Todosync.TaskTest do
  use Todosync.DataCase

  @valid %{remote_id: 1, name: "Test", user_id: 1, source: "todoist"}

  describe "Users" do
    alias Todosync.Task

    test "#synchronize#3 initial" do
      user = Todosync.Users.create("api_key")

      todoist = Enum.map(1..3, fn i ->
        %{
          "id" => i,
          "project_id" => 2202828992,
          "section_id" => 0,
          "order" => 25,
          "content" => "Second Update",
          "completed" => false,
          "label_ids" => [],
          "created" => "2020-01-20T07:29:57Z",
        }
      end)

      assert Task.synchronize(todoist, user, "todoist") == %{creations: 3}
    end

    test "#synchronize#3 incremental" do
      {:ok, user} = Todosync.Users.create("api_key")
      |> Todosync.Users.synchronized

      todoist = Enum.map(1..3, fn i ->
        %{
          "id" => i,
          "project_id" => 2202828992,
          "section_id" => 0,
          "order" => 25,
          "content" => "Second Update",
          "completed" => false,
          "label_ids" => [],
          "created" => "2020-01-20T07:29:57Z",
        }
      end)

      Task.create(Map.merge(@valid, %{remote_id: 0, user_id: user.id}))
      Task.create(Map.merge(@valid, %{remote_id: 1, user_id: user.id}))

      assert Task.synchronize(todoist, user, "todoist") == %{creations: 2, modifications: 1, deletions: 1}
    end

    test "#create/1" do
      task = Task.create(@valid)
      assert task.name == "Test"
    end

    test "#current_user_task/1" do
      user = Todosync.Users.create("api_key")
      task = Task.create(Map.merge(@valid, %{user_id: user.id}))

      assert Task.current_user_tasks(user) != nil
    end

    test "#map_from/3 with existing service" do
      user = Todosync.Users.create("api_key")

      todoist = [
        %{
          "id" => 3637711078,
          "project_id" => 2202828992,
          "section_id" => 0,
          "order" => 25,
          "content" => "Second Update",
          "completed" => false,
          "label_ids" => [],
          "created" => "2020-01-20T07:29:57Z",
        }
      ]

      tasks = Task.map_from("todoist", todoist, user)

      assert Enum.at(tasks, 0)[:remote_id] == 3637711078
    end

    test "#map_from/3 with unexisting service" do
      assert_raise RuntimeError, fn ->
       Task.map_from("anything", [], nil) == "Unknown Service"
      end
    end

  end
end
