defmodule Nitrogen.Graph do
  import Ecto.Query, warn: false

  alias Nitrogen.Notes.Notebook
  alias Nitrogen.{Notes, Repo}

  # TODO: Error handling + tests
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
      Enum.reduce(notebook.notes, {Graph.new(), []}, fn note, {g, edges} ->
        e =
          note.content
          |> Markdown.extract_links()
          |> links_to_ids()
          |> Enum.map(&{note.id, &1})

        g = Graph.add_vertex(g, note.id, note.title)
        {g, e ++ edges}
      end)

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
  Converts a Graph to valid cytoscape map
  """
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

    {:ok, json} = Jason.encode(%{nodes: nodes, edges: edges})
    json
  end
end
