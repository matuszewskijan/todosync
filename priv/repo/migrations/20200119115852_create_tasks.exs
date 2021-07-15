defmodule Todosync.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :user_id, :integer
      add :remote_id, :integer
      add :project_id, :integer
      add :name, :string
      add :completed, :boolean, default: false, null: false
      add :source, :string

      timestamps()
    end
  end

  def down do
    drop table(:tasks)
  end
end
