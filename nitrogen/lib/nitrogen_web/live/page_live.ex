defmodule NitrogenWeb.PageLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note

  @impl true
  def handle_event("render_note", %{"value" => raw}, socket) do
    rendered = Note.render(%Note{content: raw})

    {:noreply, assign(socket, rendered_note: rendered)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, rendered_note: "")}
  end
end
