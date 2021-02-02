defmodule Nitrogen.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Nitrogen.{Repo, User}
  alias Nitrogen.Notes.Notebook

  schema "users" do
    field :name, :string

    has_many :notebooks, Notebook

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :notes])
    |> validate_required([:name])
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_and_notes!(id) do
    Repo.get!(User, id)
    |> Repo.preload([:notebooks, notebooks: :notes])
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = note, attrs) do
    note
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
