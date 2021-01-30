defmodule Nitrogen.NotesTest do
  use Nitrogen.DataCase

  alias Nitrogen.Note

  describe "notes" do
    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def note_fixture(attrs \\ %{}) do
      {:ok, note} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Note.create_note()

      note
    end

    test "simple rendering works" do
      note = %Note{content: "# Hello world!"}
      assert Note.render(note) == "<h1>Hello world!</h1>\n"
    end

  #   test "list_notes/0 returns all notes" do
  #     note = note_fixture()
  #     assert Note.list_notes() == [note]
  #   end

  #   test "get_note!/1 returns the note with given id" do
  #     note = note_fixture()
  #     assert Notes.get_note!(note.id) == note
  #   end

  #   test "create_note/1 with valid data creates a note" do
  #     assert {:ok, %Note{} = note} = Notes.create_note(@valid_attrs)
  #     assert note.content == "some content"
  #     assert note.title == "some title"
  #   end

  #   test "create_note/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Notes.create_note(@invalid_attrs)
  #   end

  #   test "update_note/2 with valid data updates the note" do
  #     note = note_fixture()
  #     assert {:ok, %Note{} = note} = Notes.update_note(note, @update_attrs)
  #     assert note.content == "some updated content"
  #     assert note.title == "some updated title"
  #   end

  #   test "update_note/2 with invalid data returns error changeset" do
  #     note = note_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
  #     assert note == Notes.get_note!(note.id)
  #   end

  #   test "delete_note/1 deletes the note" do
  #     note = note_fixture()
  #     assert {:ok, %Note{}} = Notes.delete_note(note)
  #     assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(note.id) end
  #   end

  #   test "change_note/1 returns a note changeset" do
  #     note = note_fixture()
  #     assert %Ecto.Changeset{} = Notes.change_note(note)
  #   end
  end
end
