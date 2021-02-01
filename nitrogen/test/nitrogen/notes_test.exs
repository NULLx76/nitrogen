defmodule Nitrogen.NotesTest do
  use Nitrogen.DataCase

  alias Nitrogen.Notes.Note
  alias Nitrogen.Notes

  import Nitrogen.Factory

  describe "notes" do
    test "simple rendering works" do
      note = %Note{content: "# Hello world!"}
      assert Notes.render_note(note) == "<h1>Hello world!</h1>\n"
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
  end
end
