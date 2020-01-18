defmodule TodosyncWeb.UsersController do
  use TodosyncWeb, :controller

  def show(conn, params) do
    user = Todosync.Users.find_by_auth_key(params["id"])
    render(conn, "show.json", user: user)
  end

  def create(conn, params) do
    response = Todosync.ApiWrapper.Todoist.client(params["api_key"])
    |> Todosync.ApiWrapper.Todoist.verify!

    case response.status do
      200 ->
        render(conn, "auth.json", user: Todosync.Users.create(params["api_key"]))
      _ ->
        render(conn, "error.json", data: response)
    end
  end
end
