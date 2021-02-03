defmodule Nitrogen.Graph do
  import Ecto.Query, warn: false

  alias Nitrogen.Notes.Notebook
  alias Nitrogen.{Notes, Repo}

  @spec links_to_ids([binary()]) :: [integer()]
  def links_to_ids(links) do
    links
    |> Enum.reduce([], fn el, acc ->
      with "/notes/" <> id <- el,
           {n, ""} <- Integer.parse(id) do
        [n | acc]
      else
        _ -> acc
      end
    end)
  end

  @spec build_graph(%Notebook{}) :: Graph.t()
  def build_graph(%Notebook{} = notebook) do
    {g, e} =
      Enum.reduce(notebook.notes, {Graph.new, []}, fn note, {g, edges} ->
        e =
          note.content
          |> Markdown.extract_links()
          |> links_to_ids()
          |> Enum.map(&{note.id, &1})

        {Graph.add_vertex(g, note.id, note.title), e ++ edges}
      end)

    # Prune edges to non existing nodes
    vx = Graph.vertices(g)
    e = Enum.filter(e, &(elem(&1, 0) in vx and elem(&1, 1) in vx))

    Graph.add_edges(g, e)
  end

  @doc """
  Retrieves a notebook from the db and builds a graph from it.
  """
  @spec retrieve_graph(integer()) :: Graph.t()
  def retrieve_graph(notebook_id) do
    Notes.get_notebook!(notebook_id)
    |> Repo.preload(:notes)
    |> build_graph()
  end

  @doc """
  Converts a Graph to valid cytoscape JSON
  """
  @spec to_json(Graph.t()) :: binary()
  def to_json(graph) do
    nodes =
      Enum.reduce(graph.vertices, [], fn {id, v}, acc ->
        v_label = Graph.Serializer.get_vertex_label(graph, id, v) |> String.trim(~s("))
        [%{data: %{id: v, label: v_label}} | acc]
      end)

    edges =
      Graph.edges(graph)
      |> Enum.reduce([], fn %Graph.Edge{v1: source, v2: target}, acc ->
        [%{data: %{id: "#{source}#{target}", source: source, target: target}} | acc]
      end)

    Jason.encode!(%{nodes: nodes, edges: edges})
  end
end
