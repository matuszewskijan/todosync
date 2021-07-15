defmodule Todosync.Users do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

  schema "users" do
    field :auth_key, :string
    field :r_t_m_key, :string
    field :todoist_key, :string
    field :last_sync_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:auth_key, :todoist_key, :r_t_m_key, :last_sync_at])
    |> validate_required([:todoist_key])
  end

  def create(api_key, service \\ "todoist") do
    if user = Todosync.Users.find_by_service(service, api_key) do
      user
    else
      {:ok, user} = %Todosync.Users{}
      |> Todosync.Users.changeset(%{auth_key: Ecto.UUID.generate, "#{service}_key": api_key})
      |> Todosync.Repo.insert

      user
    end
  end

  def find_by_service(service, api_key) do
    case service do
      "todoist" ->
        find_by_todoist_key(api_key)
      _ ->
        raise "Not Implemented"
    end
  end

  def find_by_auth_key(auth_key) do
    (Ecto.Query.from u in Todosync.Users,
    where: u.auth_key == ^auth_key)
    |> Todosync.Repo.one
  end

  def find_by_todoist_key(api_key) do
    (Ecto.Query.from u in Todosync.Users,
    where: u.todoist_key == ^api_key)
    |> Todosync.Repo.one
  end

  def synchronized(user) do
    now = DateTime.utc_now |> DateTime.to_naive |> NaiveDateTime.truncate(:second)

    user
    |> Ecto.Changeset.change(%{last_sync_at: now})
    |> Todosync.Repo.update()
  end
end
