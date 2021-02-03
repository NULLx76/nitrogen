defmodule Nitrogen.Notes.Notebook do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nitrogen.Notes.Note
  alias Nitrogen.User

  schema "notebooks" do
    field :name, :string

    belongs_to :user, User
    has_many :notes, Note

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:name, :user_id])
    |> cast_assoc(:user)
    |> cast_assoc(:notes)
    |> foreign_key_constraint(:user_id)
  end
end
