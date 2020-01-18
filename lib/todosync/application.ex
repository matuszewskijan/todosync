defmodule Todosync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Todosync.Repo,
      # Start the endpoint when the application starts
      TodosyncWeb.Endpoint
      # Starts a worker by calling: Todosync.Worker.start_link(arg)
      # {Todosync.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Todosync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TodosyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
