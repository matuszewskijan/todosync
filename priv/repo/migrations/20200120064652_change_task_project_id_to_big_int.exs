defmodule Todosync.Repo.Migrations.ChangeTaskProjectIdToBigInt do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify :project_id, :bigint
    end
  end
end
