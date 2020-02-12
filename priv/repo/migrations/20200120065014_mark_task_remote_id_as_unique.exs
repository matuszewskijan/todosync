defmodule Todosync.Repo.Migrations.MarkTaskRemoteIdAsUnique do
  use Ecto.Migration

  def up do
    create unique_index(:tasks, [:remote_id])
  end

  def down do
    drop_if_exists unique_index(:tasks, [:remote_id])
  end
end
