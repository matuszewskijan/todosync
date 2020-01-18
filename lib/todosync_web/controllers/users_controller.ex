defmodule TodosyncWeb.UsersController do
  use TodosyncWeb, :controller

  def show(conn, _params) do
    render(conn, "show.json", data: %{success: true})
  end

  def create(conn, _params) do
    render(conn, "auth.json", data: %{success: true})
  end
end
