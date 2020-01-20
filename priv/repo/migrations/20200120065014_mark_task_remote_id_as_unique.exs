defmodule Todosync.Repo.Migrations.MarkTaskRemoteIdAsUnique do
  use Ecto.Migration

  def change do
    create unique_index(:tasks, [:remote_id])
  end
end
