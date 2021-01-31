defmodule NitrogenWeb.PageLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note

  @impl true
  def handle_event("update", %{"value" => raw}, socket) do
    rendered = Note.render(%Note{content: raw})

    {:noreply, assign(socket, md: rendered, raw_md: raw)}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, md: "", raw_md: "")}
  end
end
