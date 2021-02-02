defmodule Nitrogen.GraphTest do
  use Nitrogen.DataCase

  alias Nitrogen.Notes.{Note, Notebook}
  alias Nitrogen.Notes

  test "graph construction" do
    nb = %Notebook{
      id: 1,
      name: "Notebook 1",
      notes: [
        %Note{
          id: 1,
          title: "Note 1",
          content: "[Note 2](/notes/2)"
        },
        %Note{
          id: 2,
          title: "Note 2",
          content: "[Note 1](/notes/1)"
        },
        %Note{
          id: 3,
          title: "Note 3",
          content: "[Note 1](/notes/1)\n[Note 2](/notes/2)"
        },
        %Note{
          id: 4,
          title: "Note 4",
          content: "[Note 3](/notes/3)\n[Note 2](/notes/2)\n[Note 1](/notes/1)"
        }
      ]
    }

    g = Nitrogen.Graph.build_graph(nb)

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
end
