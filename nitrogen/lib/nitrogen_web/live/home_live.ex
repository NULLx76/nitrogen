defmodule NitrogenWeb.HomeLive do
  use NitrogenWeb, :live_view
  alias NitrogenWeb.Component

  @impl true
  def handle_params(%{"id" => id}, _session, socket) do
    {:noreply, assign(socket, :note_id, id)}
  end

  @impl true
  def handle_params(_params,_session,socket) do
    {:noreply, assign(socket, :note_id, 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="content">
      <Component.Navigation />

      <NitrogenWeb.NoteLive id="content-editor" :if={{@note_id != 0}} session={{ %{"note_id" => @note_id} }} />

      <span :if={{ @note_id == 0 }}>
        Lorem Ipsum
        <button class="b-button">button</button>
      </span>
    </div>
    """
  end
end
