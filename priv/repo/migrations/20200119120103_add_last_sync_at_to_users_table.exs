defmodule Todosync.Repo.Migrations.AddLastSyncAtToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_sync_at, :naive_datetime
    end
  end
end
