defmodule Todosync.Repo do
  use Ecto.Repo,
    otp_app: :todosync,
    adapter: Ecto.Adapters.Postgres
end
