# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Nitrogen.Repo.insert!(%Nitrogen.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Insert user, initial notebook and example note
user = Nitrogen.Repo.insert!(%Nitrogen.User{name: "user"}).id

notebook =
  Nitrogen.Repo.insert!(%Nitrogen.Notes.Notebook{
    name: "Initial Notebook",
    user_id: user
  }).id

notebook2 =
  Nitrogen.Repo.insert!(%Nitrogen.Notes.Notebook{
    name: "Second Notebook",
    user_id: user
  }).id

Nitrogen.Repo.insert!(%Nitrogen.Notes.Note{
  title: "Example Note",
  content: "# Example Note

  * [Note 2](/notes/2)
  ",
  notebook_id: notebook
})

Nitrogen.Repo.insert!(%Nitrogen.Notes.Note{
  title: "Example Note 2",
  content: "# Example Note 2

  * [Note 1](/notes/1)
  ",
  notebook_id: notebook
})

Nitrogen.Repo.insert!(%Nitrogen.Notes.Note{
  title: "Example Note 3",
  content: "# Example Note 3",
  notebook_id: notebook2
})

Nitrogen.Repo.insert!(%Nitrogen.Notes.Note{
  title: "Example Note 4",
  content: "# Example Note 4",
  notebook_id: notebook2
})
