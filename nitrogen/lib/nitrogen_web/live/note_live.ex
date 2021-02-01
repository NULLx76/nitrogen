defmodule NitrogenWeb.NoteLive do
  use Surface.LiveView
  alias Nitrogen.Notes.Note
  alias Nitrogen.Notes
  alias NitrogenWeb.Component

  @sched_store :store

  data note, :any
  data new_note, :any
  data content, :string, default: ""
  data md, :string, default: ""
  data edit_title, :boolean, default: false

  defp schedule_save do
    Process.send_after(self(), @sched_store, 5_000)
  end

  defp save_note(socket) do
    Notes.update_note(socket.assigns.note, Map.from_struct(socket.assigns.new_note))
  end

  @impl true
  def handle_event("update", %{"value" => raw}, socket) do
    new_note = %Note{socket.assigns.new_note | content: raw}
    md = Notes.render_note(new_note)

    {:noreply, assign(socket, new_note: new_note, md: md)}
  end

  @impl true
  def handle_event("edit-title", _params, socket) do
    {:noreply, assign(socket, edit_title: true)}
  end

  @impl true
  def handle_event("save-title", %{"title" => title}, socket) do
    new_note = %Note{socket.assigns.new_note | title: title}
    socket = assign(socket, new_note: new_note, edit_title: false)
    {:ok, %Note{}} = save_note(socket)
    NitrogenWeb.Endpoint.broadcast_from(self(), "title-update", "new_note.id", new_note)
    {:noreply, socket}
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

  def mount(_params, %{"note_id" => id}, socket) do
    note = Notes.get_note!(id)
    md = Notes.render_note(note)

    schedule_save()

    {:ok,
     assign(socket, note: note, new_note: note, content: note.content, md: md, edit_title: false)}
  end
end
