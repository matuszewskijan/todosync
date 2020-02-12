defmodule Todosync.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :auth_key, :string
      add :todoist_key, :string
      add :r_t_m_key, :string

      timestamps()
    end
  end

  def down do
    drop table(:users)
  end
end
