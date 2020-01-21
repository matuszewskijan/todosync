defmodule TodosyncWeb.SynchronizationController do
  use TodosyncWeb, :controller

  alias Todosync.ApiWrapper.Todoist

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

  def sync(conn, params) do
    case params["service"] do
      "todoist" ->
        tasks = Todoist.client(conn.assigns.user.todoist_key) |> Todoist.list
        sync_info = Todosync.Task.synchronize(tasks.body, conn.assigns.user, "todoist")
        render(conn, "show.json", sync_info: sync_info)
      "remember_the_milk" ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 400, message: "Not Implemented."})
      "all" ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 400, message: "Not Implemented."})
      _ ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 400, message: "Unknown service."})
    end
  end

end

