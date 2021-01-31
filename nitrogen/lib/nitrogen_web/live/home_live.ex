defmodule NitrogenWeb.HomeLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _session, socket) do
    {:noreply, assign(socket, note_id: id)}
  end

  def handle_params(_params, _session, socket) do
    {:noreply, assign(socket, note_id: 0)}
  end

  def handle_event("click", _data, socket) do
    {:noreply, assign(socket, note_id: 1)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="content">
      <%= live_component @socket, NitrogenWeb.NavigationComponent %>
      <%= if @note_id > 0 do %>
        <%= live_render @socket, NitrogenWeb.NoteLive, id: "editor-view", session: %{"note_id" => @note_id} %>
      <%= else %>
        Lorem Ipsum
      <% end %>
    </div>
    """
  end
end
