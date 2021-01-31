defmodule Nitrogen.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :text
      add :user_id, references(:users), null: false

      timestamps()
    end

    create unique_index(:notes, [:title, :user_id])
  end
end
