defmodule Todosync.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :auth_key, :string
    field :r_t_m_key, :string
    field :todoist_key, :string

    timestamps()
  end

  @doc false
  def changeset(users, attrs) do
    users
    |> cast(attrs, [:id, :auth_key, :todoist_key, :r_t_m_key])
    |> validate_required([:id, :auth_key, :todoist_key, :r_t_m_key])
  end
end
