defmodule TodosyncWeb.PageControllerTest do
  use TodosyncWeb.ConnCase

  test "GET /auth", %{conn: conn} do
    conn = get(conn, "/auth/1")
    assert json_response(conn, 200) == %{"success" => true}
  end

  test "POST /auth", %{conn: conn} do
    conn = post(conn, "/auth")
    assert json_response(conn, 200) == %{"success" => true}
  end
end
