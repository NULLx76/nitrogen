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
    |> cast(attrs, [:name, :user, :user_id, :notes])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
