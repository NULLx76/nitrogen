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

# Insert user and example note
user = Nitrogen.Repo.insert!(%Nitrogen.User{name: "user"}).id

Nitrogen.Repo.insert!(%Nitrogen.Note{
  title: "Example Note",
  content: "# Example Note",
  user_id: user
})
