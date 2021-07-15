defmodule Todosync.Task do
  import Ecto.Changeset
  import Ecto.Query
  use Ecto.Schema

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
      existing_tasks = Todosync.Task
      |> filter_by_source(service)
      |> filter_by_current_user(user)
      |> Todosync.Repo.all

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

  def create(task, _service \\ "todoist") do
    {:ok, task} = %Todosync.Task{}
    |> Todosync.Task.changeset(task)
    |> Todosync.Repo.insert

    task
  end

  def update(task, changes) do
    {:ok, task} = task
    |> Todosync.Task.changeset(changes)
    |> Todosync.Repo.update

    task
  end

  def filter_by_current_user(query, user) do
    from t in query,
    where: t.user_id == ^user.id
  end

  def filter_by_name(query, name) do
    if name do
      from t in query,
      where: t.name == ^name
    else
      query
    end
  end

  def filter_by_source(query, source) do
    if source do
      from t in query,
      where: t.source == ^source
    else
      query
    end
  end

  def map_from(service, tasks, user) do
    case service do
      "todoist" -> Todosync.FieldMapper.Todoist.map_from(tasks, user)
      _ -> raise "Unknown Service"
    end
  end

  def map_to(service, tasks) do
    case service do
      "todoist" -> Todosync.FieldMapper.Todoist.map_to(tasks)
      _ -> raise "Unknown Service"
    end
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
