defmodule Nitrogen.Graph do
  alias Nitrogen.Notes.Notebook

  defp links_to_id(links) do
    Enum.map(links, fn link ->
      "/notes/" <> id = link
      String.to_integer(id)
    end)
  end

  @spec build_graph(%Notebook{}) :: Graph.t()
  def build_graph(%Notebook{} = notebook) do
    {g, e} = Enum.reduce(notebook.notes, {Graph.new(), []}, fn note, {g, edges} ->
      e = Markdown.extract_links(note.content)
          |> links_to_id()
          |> Enum.map(& {note.id, &1})

      {Graph.add_vertex(g, note.id, note.title), e ++ edges}
    end)

    Graph.add_edges(g, e)
  end
end
