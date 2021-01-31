defmodule NitrogenWeb.NoteLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note

  @sched_store :store

  defp schedule_save do
    Process.send_after(self(), @sched_store, 5_000)
  end

  defp save_note(socket) do
    Note.update_note(socket.assigns.note, Map.from_struct(socket.assigns.new_note))
  end

  @impl true
  def handle_event("update", %{"value" => raw}, socket) do
    new_note = %Note{socket.assigns.new_note | content: raw}
    md = Note.render(new_note)

    {:noreply, assign(socket, new_note: new_note, md: md)}
  end

  @impl true
  def handle_info(@sched_store, socket) do
    {:ok, note} = save_note(socket)
    schedule_save()
    {:noreply, assign(socket, note: note, new_note: note)}
  end

  @impl true
  def terminate(_reason, socket) do
    {:ok, %Note{}} = save_note(socket)
    :ok
  end

  @impl true
  def mount(_params, session, socket) do
    id = Map.fetch!(session, "note_id")
    note = Note.get_note!(id)
    md = Note.render(note)

    schedule_save()

    {:ok, assign(socket, note: note, new_note: note, content: note.content, md: md)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="editor-wrapper">
      <div class="toolbar">
        <h2 class="note-name"><%= @new_note.title %></h2>
      </div>
      <div class="editor">
        <div class="input">
          <%= live_component @socket, NitrogenWeb.MonacoComponent, id: "monaco", raw_md: @content %>
        </div>
        <div class="output">
          <%= live_component @socket, NitrogenWeb.MarkdownComponent, md: @md %>
        </div>
      </div>
    </div>
    """
  end
end
