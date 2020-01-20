defmodule Todosync.ApiWrapper.Todoist do
  @moduledoc """
  Todoist API wrapper
  """

  use Tesla
  alias Todosync.ApiWrapper.Todoist

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

  def list(client) do
    { :ok, response } = Tesla.get(client, "/tasks")

    response
  end

  def find(client, id) do
    { :ok, response } = Tesla.get(client, "/tasks/#{id}")

    response
  end

  def create(client, data) do
    { :ok, response } = Tesla.post(client, "/tasks", data)

    response
  end

  def update(client, changes) do
    Tesla.post(client, "/tasks/#{changes[:id]}", %{content: changes.content})
  end
end
