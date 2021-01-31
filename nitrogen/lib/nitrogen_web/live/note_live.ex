defmodule NitrogenWeb.NoteLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note

  @impl true
  def handle_event("update", %{"value" => raw}, socket) do
    rendered = Note.render(%Note{content: raw})

    {:noreply, assign(socket, md: rendered)}
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    note = Note.get_note!(id)
    md = Note.render(note)

    {:ok, assign(socket, md: md, raw_md: note.content)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="editor">
      <div class="input">
        <%= live_component @socket, NitrogenWeb.MonacoComponent, id: "monaco", raw_md: @raw_md %>
      </div>
      <div class="output">
        <%= live_component @socket, NitrogenWeb.MarkdownComponent, md: @md %>
      </div>
    </div>
    """
  end
end
