defmodule TodosyncWeb.SynchronizationController do
  use TodosyncWeb, :controller

  alias Todosync.ApiWrapper.Todoist

  plug :authenticate

  defp authenticate(conn, _) do
    auth_key = Enum.at(get_req_header(conn, "authorization"), 0)
    if (user = Todosync.Users.find_by_auth_key(auth_key)) do
      assign(conn, :user, user)
    else
      conn
      |> send_resp(403, "Authorization key not found or invalid!") # TODO: Check if we can return JSON here
      |> halt
    end
  end

  def sync(conn, params) do
    tasks = Todoist.client(conn.assigns.user.todoist_key) |> Todoist.list
    sync_info = Todosync.Task.synchronize(tasks.body, conn.assigns.user, "todoist")
    render(conn, "show.json", sync_info: sync_info)
  end

end
