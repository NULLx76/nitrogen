defmodule Nitrogen.Note do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Nitrogen.{Repo, Note}
  alias Markdown

  schema "notes" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  def render(%Note{} = note) do
    Markdown.render_simple(note.content)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content])
    |> validate_required([:title])
  end

  def list_notes do
    Repo.all(Note)
  end

  def get_note!(id), do: Repo.get!(Note, id)

  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
