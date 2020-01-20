defmodule TodosyncWeb.TasksView do
  use TodosyncWeb, :view

  def render("index.json", data) do
    data.conn.assigns.tasks
    |> Enum.map(fn task ->
      %{
        id: task.id,
        remote_id: task.remote_id,
        name: task.name,
        source: task.source,
        completed: task.completed
      }
    end)
  end

  def render("update.json", data) do
    %{
      id: data.task.id,
      remote_id: data.task.remote_id,
      name: data.task.name,
      source: data.task.source,
      completed: data.task.completed
    }
  end

  def render("error.json", response) do
    %{code: response.data.status, message: response.data.body}
  end

end
