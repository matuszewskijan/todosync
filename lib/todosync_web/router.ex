defmodule TodosyncWeb.Router do
  use TodosyncWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodosyncWeb do
    pipe_through :api

    resources "/auth", UsersController, only: [:show, :create]

    post "/sync", SynchronizationController, :sync
  end
end
