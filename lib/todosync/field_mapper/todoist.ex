defmodule Todosync.FieldMapper.Todoist do
  def map_from(tasks, user) do
    now = DateTime.utc_now |> DateTime.to_naive |> NaiveDateTime.truncate(:second)
    tasks
    |> Enum.with_index
    |> Enum.map(fn {task, _i} ->
      {:ok, inserted_at, 0} = DateTime.from_iso8601(task["created"])

      %{
        name: task["content"],
        remote_id: task["id"],
        source: "todoist",
        project_id: task["project_id"],
        inserted_at: DateTime.to_naive(inserted_at),
        updated_at: now,
        completed: task["completed"],
        user_id: user.id
      }
    end)
  end

  def map_to(tasks) do
    tasks
    |> List.wrap
    |> Enum.with_index
    |> Enum.map(fn {task, _i} ->
      %{
        content: task["name"],
        id: task["remote_id"],
        project_id: task["project_id"],
        completed: task["completed"]
      }
    end)
  end
end
