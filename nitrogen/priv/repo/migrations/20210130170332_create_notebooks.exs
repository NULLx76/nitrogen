defmodule Nitrogen.Repo.Migrations.CreateNotebooks do
  use Ecto.Migration

  def change do
    create table(:notebooks) do
      add :name, :string
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
