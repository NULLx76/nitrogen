defmodule NitrogenWeb.Component.Graph do
  use Surface.LiveComponent

  prop notebook, :map, required: true
  data graph, :map

  @impl true
  def update(assigns, socket) do
    graph =
      Nitrogen.Graph.build_graph(assigns.notebook)
      |> Nitrogen.Graph.to_json()

    socket = assign(socket, assigns)
    socket = assign(socket, graph: graph)

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div id="cy-{{ @id }}-container" class="cy" phx-update="ignore"></div>
      <div id="cy-{{ @id }}" phx-hook="CytoScape" data-graph={{ @graph }}></div>
    </div>
    """
  end
end
