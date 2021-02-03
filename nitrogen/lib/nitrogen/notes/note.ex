defmodule Nitrogen.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nitrogen.Notes.Notebook

  schema "notes" do
    field :title, :string
    field :content, :string

    belongs_to :notebook, Notebook

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :notebook_id])
    |> validate_required([:title, :notebook_id])
    |> foreign_key_constraint(:notebook_id)
  end
end
