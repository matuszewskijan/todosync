defmodule TodosyncWeb.Router do
  use TodosyncWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TodosyncWeb do
    pipe_through :api

    resources "/auth", UsersController, only: [:show, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TodosyncWeb do
  #   pipe_through :api
  # end
end
