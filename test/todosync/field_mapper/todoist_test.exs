defmodule Todosync.FieldMapper.TodoistTest do
  use Todosync.DataCase

  describe "Users" do
    alias Todosync.FieldMapper.Todoist

    test "#map_from/2" do
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

      tasks = Todoist.map_from(todoist, user)

      assert Enum.at(tasks, 0)[:remote_id] == 3637711078
    end

    test "#map_to/1" do
      todoist = [
        %{
          "remote_id" => 3637711078,
          "project_id" => 2202828992,
          "name" => "Second Update",
          "completed" => false
        }
      ]

      tasks = Todoist.map_to(todoist)

      assert Enum.at(tasks, 0)[:id] == 3637711078
      assert Enum.at(tasks, 0)[:content] == "Second Update"
    end

  end
end
