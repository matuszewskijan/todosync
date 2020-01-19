defmodule Todosync.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :name, :string
    field :project_id, :integer
    field :remote_id, :integer
    field :source, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:user_id, :remote_id, :project_id, :name, :completed, :source])
    |> validate_required([:user_id, :remote_id, :project_id, :name, :completed, :source])
  end
end
