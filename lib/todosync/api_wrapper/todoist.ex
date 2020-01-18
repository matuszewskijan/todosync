defmodule Todosync.ApiWrapper.Todoist do
  @moduledoc """
  Todoist API wrapper
  """

  use Tesla

  # build dynamic client based on runtime arguments
  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.todoist.com/rest/v1"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> token }]}
    ]

    Tesla.client(middleware)
  end

  def verify!(client) do
    { :ok, response } = Tesla.get(client, "/projects")

    response
  end
end
