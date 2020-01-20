defmodule Todosync.Task do
  use Ecto.Schema
  import Ecto.Changeset
  require Ecto.Query

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
    |> validate_required([:user_id, :remote_id, :name, :completed, :source])
  end

  def synchronize(tasks, user, service) do
    tasks = map_from(service, tasks, user)

    if user.last_sync_at == nil do
      {creations, _} = create_many(tasks)
      Todosync.Users.synchronized(user)
      %{creations: creations}
    else
      existing_tasks = current_user_tasks(user)
      create_many(tasks)
      Todosync.Users.synchronized(user)
      count_changes(existing_tasks, tasks)
    end
  end

  def create_many(tasks) do
    Todosync.Repo.insert_all(
      Todosync.Task,
      tasks,
      on_conflict: {
        :replace, [:name, :completed, :project_id, :updated_at]
      },
      conflict_target: [:remote_id]
    )
  end

  def create(task, service \\ "todoist") do
    {:ok, task} = %Todosync.Task{}
    |> Todosync.Task.changeset(task)
    |> Todosync.Repo.insert

    task
  end

  def update(id, task) do
    {:ok, task} = %Todosync.Task{}
    |> Todosync.Task.changeset(task)
    |> Todosync.Repo.update

    task
  end

  def delete(id) do
    post = Todosync.Repo.get!(Task, id)
    # case Todosync.Repo.delete post do
    #   {:ok, struct}       ->
    #   {:error, changeset} -> false
    # end

    true
  end

  def current_user_tasks(user) do
    (Ecto.Query.from t in Todosync.Task,
    where: t.user_id == ^user.id)
    |> Todosync.Repo.all
  end

  def map_from(service, tasks, user) do
    case service do
      "todoist" -> map_from_todoist(tasks, user)
      _ -> raise "Unknown Service"
    end
  end

  defp map_from_todoist(tasks, user) do
    now = DateTime.utc_now |> DateTime.to_naive |> NaiveDateTime.truncate(:second)
    tasks
    |> Enum.with_index
    |> Enum.map(fn {task, _i} ->
      {:ok, inserted_at, 0} = DateTime.from_iso8601(task["created"])

      %{
        name: task["content"],
        remote_id: task["id"],
        source: "todoist",
        project_id: task["project_id"],
        inserted_at: DateTime.to_naive(inserted_at),
        updated_at: now,
        completed: task["completed"],
        user_id: user.id
      }
    end)
  end

  defp count_changes(existing, upstream) do
    existing_ids = Enum.map(existing, fn x -> "#{x.remote_id}-#{x.name}-#{x.project_id}-#{x.completed}" end)
    upstream_ids = Enum.map(upstream, fn x -> "#{x[:remote_id]}-#{x[:name]}-#{x[:project_id]}-#{x[:completed]}" end)

    creations = upstream_ids -- existing_ids
    deletions = existing_ids -- upstream_ids

    creations_ids = Enum.map(creations, fn x -> Enum.at(String.split(x, "-"), 0) end)
    deletions_ids = Enum.map(deletions, fn x -> Enum.at(String.split(x, "-"), 0) end)

    modifications_size = MapSet.intersection(MapSet.new(creations_ids), MapSet.new(deletions_ids))
    |> Enum.count

    %{
       creations: Enum.count(creations) - modifications_size,
       deletions: Enum.count(deletions) - modifications_size,
       modifications: modifications_size
     }
  end
end
