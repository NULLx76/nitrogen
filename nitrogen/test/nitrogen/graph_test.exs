defmodule Nitrogen.GraphTest do
  use Nitrogen.DataCase
  import Nitrogen.Factory
  alias Nitrogen.Notes.{Note, Notebook}

  defp test_notebook do
    %Notebook{
      id: 1,
      name: "Notebook 1",
      notes: [
        %Note{
          id: 1,
          title: "Note 1",
          content: "[Note 2](/note/2)"
        },
        %Note{
          id: 2,
          title: "Note 2",
          content: "[Note 1](/note/1)"
        },
        %Note{
          id: 3,
          title: "Note 3",
          content: "[Note 1](/note/1)\n[Note 2](/note/2)"
        },
        %Note{
          id: 4,
          title: "Note 4",
          content: "[Note 3](/note/3)\n[Note 2](/note/2)\n[Note 1](/note/1)"
        }
      ]
    }
  end

  defp assert_graph(g) do
    assert Graph.has_vertex?(g, 1)
    assert Graph.has_vertex?(g, 2)
    assert Graph.has_vertex?(g, 3)
    assert Graph.has_vertex?(g, 4)

    assert Graph.out_edges(g, 1) == [%Graph.Edge{v1: 1, v2: 2, weight: 1}]
    assert Graph.out_edges(g, 2) == [%Graph.Edge{v1: 2, v2: 1, weight: 1}]

    assert Graph.out_edges(g, 3) == [
             %Graph.Edge{v1: 3, v2: 1, weight: 1},
             %Graph.Edge{v1: 3, v2: 2, weight: 1}
           ]

    assert Graph.out_edges(g, 4) == [
             %Graph.Edge{label: nil, v1: 4, v2: 1, weight: 1},
             %Graph.Edge{label: nil, v1: 4, v2: 3, weight: 1},
             %Graph.Edge{label: nil, v1: 4, v2: 2, weight: 1}
           ]
  end

  test "graph construction" do
    nb = test_notebook()

    Nitrogen.Graph.build_graph(nb)
    |> assert_graph()
  end

  test "graph from db retrieval" do
    nb = %Notebook{test_notebook() | user_id: insert(:user).id}
    id = insert(nb).id

    Nitrogen.Graph.retrieve_graph(id)
    |> assert_graph()
  end

  test "link to id conversion" do
    links = ["google.com", "/note/42", "/notes/5", "/notes", "/note/ ", "/note/1"]
    assert Nitrogen.Graph.links_to_ids(links) == [1, 42]
  end
end
