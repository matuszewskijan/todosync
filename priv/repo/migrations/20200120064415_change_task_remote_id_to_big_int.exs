defmodule Todosync.Repo.Migrations.ChangeTaskRemoteIdToBigInt do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify :remote_id, :bigint
    end
  end
end
