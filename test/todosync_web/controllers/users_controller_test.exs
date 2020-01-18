defmodule TodosyncWeb.UsersControllerTest do
  use TodosyncWeb.ConnCase

  test "GET /auth/:nonexisting_id", %{conn: conn} do
    conn = get(conn, "/auth/1")
    assert json_response(conn, 200) == %{"code" => 403, "message" => "Authorization key not found."}
  end

  test "GET /auth/:existing_id", %{conn: conn} do
    user = Todosync.Users.create("api_key")

    conn = get(conn, "/auth/#{user.auth_key}")
    assert json_response(conn, 200)["todoist_key"] == "api_key"
  end

  test "unsuccesful POST /auth", %{conn: conn} do
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> post("/auth", %{api_key: "invalid_key"})

    assert json_response(conn, 200)["message"] == "Forbidden\n"
  end

  test "successful POST /auth", %{conn: conn} do
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> post("/auth", %{api_key: Application.get_env(:todosync, :api_key)})

    assert json_response(conn, 200)["auth_key"] != nil
  end
end
