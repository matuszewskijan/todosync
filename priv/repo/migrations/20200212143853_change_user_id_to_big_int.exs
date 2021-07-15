defmodule Todosync.Repo.Migrations.ChangeUserIdToBigInt do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :id, :bigint
    end
  end
end
