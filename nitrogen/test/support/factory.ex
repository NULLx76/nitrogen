defmodule Nitrogen.Factory do
  use ExMachina.Ecto, repo: Nitrogen.Repo

  def user_factory do
    %Nitrogen.User{
      name: "Some User"
    }
  end

  def notebook_factory do
    %Nitrogen.Notes.Notebook{
      name: "Some Notebooks",
      user: build(:user)
    }
  end

  def note_factory do
    %Nitrogen.Notes.Note{
      title: "Some Note",
      content: "Some content",
      notebook: build(:notebook)
    }
  end
end
