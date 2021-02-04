defmodule Nitrogen.Notes do
  import Ecto.Query, warn: false
  alias Nitrogen.Repo
  alias Nitrogen.Notes.{Note, Notebook}
  alias Markdown

  # Notes

  def list_notes do
    Repo.all(Note)
    |> Repo.preload(:notebook)
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

  def render_note(%Note{} = note) do
    Markdown.render_simple(note.content || "")
  end

  # Notebooks
  def list_notebooks do
    Repo.all(Notebook)
  end

  def get_notebook!(id), do: Repo.get!(Notebook, id)

  def create_notebook(attrs \\ %{}) do
    %Notebook{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update_notebook(%Notebook{} = note, attrs) do
    note
    |> Notebook.changeset(attrs)
    |> Repo.update()
  end

  def change_notebook(%Notebook{} = note, attrs \\ %{}) do
    Notebook.changeset(note, attrs)
  end
end
