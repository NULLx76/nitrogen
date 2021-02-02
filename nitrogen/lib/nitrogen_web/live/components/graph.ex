defmodule NitrogenWeb.Component.Graph do
  use Surface.LiveComponent

  prop notebook_id, :integer, required: true

  data graph, :any

  @impl true
  def preload(list_of_assigns) do
    list_of_assigns
  end

  @impl true
  def update(assigns, socket) do
    data = Nitrogen.Graph.retrieve_graph(assigns.notebook_id)
      |> Nitrogen.Graph.to_json()

    socket = assign(socket, assigns)
    socket = assign(socket, graph: data)

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="cy-{{ @id }}" style="width: 500px; height: 500px; display: block;" data-graph={{ @graph }} phx-hook="CytoScape"></div>
    """
  end
end
