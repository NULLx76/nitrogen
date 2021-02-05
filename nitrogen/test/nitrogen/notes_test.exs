defmodule Nitrogen.NotesTest do
  use Nitrogen.DataCase

  alias Nitrogen.Notes.{Note, Notebook}
  alias Nitrogen.Notes

  import Nitrogen.Factory

  describe "notes" do
    test "simple rendering works" do
      note = %Note{content: "# Hello world!"}
      assert Notes.render_note(note, %Notebook{notes: []}) |> elem(0) == "<h1>Hello world!</h1>\n"
    end

    test "smart link rendering works" do
      note = %Note{content: "[Hello World]"}
      notebook = %Notebook{notes: [%Note{id: 42, title: "Hello World"}]}
      expected = "<p><a data-phx-link=\"redirect\" data-phx-link-state=\"push\" href=\"/note/42\" title=\"Hello World\">Hello World</a></p>\n"
      assert Notes.render_note(note, notebook) |> elem(0) == expected
    end

    test "list_note/0 returns all notes" do
      note = insert(:note)
      notes = Notes.list_notes()

      assert length(notes) == 1
      assert Enum.at(notes, 0).title == note.title
    end
  end

  describe "notebooks" do
    test "list_notebooks/0 returns all notebooks" do
      notebook = insert(:notebook)
      notebooks = Notes.list_notebooks()

      assert length(notebooks) == 1
      assert Enum.at(notebooks, 0).name == notebook.name
    end

    test "get notebook, modify and save" do
      initial = insert(:notebook)

      notebook =
        Notes.get_notebook!(initial.id)
        |> Nitrogen.Repo.preload(:notes)

      assert length(notebook.notes) == 0

      notebook = %{id: notebook.id, notes: [%{title: "Some New Note", content: "42"}]}

      {:ok, _} = Notes.update_notebook(%Notebook{id: initial.id}, notebook)

      notebook =
        Notes.get_notebook!(initial.id)
        |> Nitrogen.Repo.preload(:notes)

      assert length(notebook.notes) == 1

      note = hd(notebook.notes)
      assert note.title == "Some New Note"
      assert note.content == "42"
    end
  end
end
