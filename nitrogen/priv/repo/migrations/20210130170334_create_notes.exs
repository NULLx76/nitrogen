defmodule Nitrogen.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :text

      add :notebook_id, references(:notebooks), null: false

      timestamps()
    end
  end
end
