defmodule Todosync.Repo.Migrations.AddLastSyncAtToUsersTable do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :last_sync_at, :naive_datetime
    end
  end

  def down do
    alter table(:users) do
      remove :last_sync_at
    end
  end
end
