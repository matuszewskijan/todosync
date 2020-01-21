defmodule TodosyncWeb.SynchronizationControllerTest do
  use TodosyncWeb.ConnCase

  @api_key Application.get_env(:todosync, :api_key)

  test "POST /sync without auth key", %{conn: conn} do
    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", "")
    |> post("/sync", %{service: "todoist"})

    assert json_response(conn, 200) == %{"code" => 403, "message" => "Authorization key not found or invalid!"}
  end

  test "POST /sync with unknown service", %{conn: conn} do
    user = Todosync.Users.create(@api_key)

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", user.auth_key)
    |> post("/sync", %{service: "random"})

    assert json_response(conn, 200) == %{"code" => 400, "message" => "Unknown service."}
  end

  test "POST /sync with not implemented service", %{conn: conn} do
    user = Todosync.Users.create(@api_key)

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", user.auth_key)
    |> post("/sync", %{service: "all"})

    assert json_response(conn, 200) == %{"code" => 400, "message" => "Not Implemented."}
  end

  test "POST /sync with auth key", %{conn: conn} do
    user = Todosync.Users.create(@api_key)

    conn = conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", user.auth_key)
    |> post("/sync", %{service: "todoist"})

    response = json_response(conn, 200)

    assert response["creations"] >= 0
    assert response["deletions"] >= 0
    assert response["modifications"] >= 0
  end
end
