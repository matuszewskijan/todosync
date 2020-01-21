defmodule TodosyncWeb.TasksController do
  use TodosyncWeb, :controller

  alias Todosync.ApiWrapper.Todoist
  alias Todosync.Task
  plug :authenticate

  defp authenticate(conn, _) do
    auth_key = Enum.at(get_req_header(conn, "authorization"), 0)
    if user = Todosync.Users.find_by_auth_key(auth_key) do
      assign(conn, :user, user)
    else
      conn
      |> render(TodosyncWeb.ErrorView, "error.json", %{code: 403, message: "Authorization key not found or invalid!"})
      |> halt
    end
  end

  def index(conn, params) do
    tasks = Task
    |> Task.filter_by_current_user(conn.assigns.user)
    |> Task.filter_by_name(params["name"])
    |> Task.filter_by_source(params["source"])
    |> Todosync.Repo.all

    render(conn, "index.json", tasks: tasks)
  end

  def update(conn, params) do
    task = Todosync.Repo.get(Task, params["id"])

    if task do
      mapped_task = Task.map_to(task.source, Map.merge(params, %{"remote_id" => task.remote_id}))
      |> Enum.at(0)

      {:ok, response} = Todosync.ApiWrapper.Todoist.client(conn.assigns.user.todoist_key)
      |> Todosync.ApiWrapper.Todoist.update(mapped_task)

      case response.status do
        204 ->
          render(conn, "update.json", task: Task.update(task, params))
        _ ->
          render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 422, error: "Failed to update."})
      end
    end
  end
end
