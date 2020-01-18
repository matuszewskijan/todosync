defmodule TodosyncWeb.PageController do
  use TodosyncWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
