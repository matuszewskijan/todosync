defmodule TodosyncWeb.UsersController do
  use TodosyncWeb, :controller

  def show(conn, params) do
    user = Todosync.Users.find_by_auth_key(params["id"])
    render(conn, "show.json", user: user)
  end

  def create(conn, params) do
    case params["service"] do
      "todoist" ->
        todoist_authorization(conn, params["api_key"])
      "remember_the_milk" ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 403, message: "Not Implemented"})
      _ ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: 403, message: "Unknown Service"})
    end
  end

  defp todoist_authorization(conn, api_key) do
    response = Todosync.ApiWrapper.Todoist.client(api_key)
    |> Todosync.ApiWrapper.Todoist.verify!

    case response.status do
      200 ->
        render(conn, "auth.json", user: Todosync.Users.create(api_key, "todoist"))
      _ ->
        render(conn, TodosyncWeb.ErrorView, "error.json", %{code: response.status, message: response.body})
    end
  end
end
