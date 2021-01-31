defmodule NitrogenWeb.NoteLive do
  use NitrogenWeb, :live_view
  alias Nitrogen.Note
  alias NitrogenWeb.Component

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
  def handle_event("edit-title", _params, socket) do
    {:noreply, assign(socket, edit_title: true)}
  end

  @impl true
  def handle_event("save-title", %{"title" => title}, socket) do
    new_note = %Note{socket.assigns.new_note | title: title}
    socket = assign(socket, new_note: new_note, edit_title: false)
    {:ok, %Note{}} = save_note(socket)
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

  @impl true
  def mount(_params, %{"note_id" => id}, socket) do
    note = Note.get_note!(id)
    md = Note.render(note)

    schedule_save()

    {:ok,
     assign(socket, note: note, new_note: note, content: note.content, md: md, edit_title: false)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="editor-wrapper">
      <div class="toolbar">
        <%= if @edit_title do %>
          <form phx-submit="save-title">
            <input name="title" type="text" value="<%= @new_note.title %>">
            <button type="submit">[save]</button>
          </form>
        <%= else  %>
          <div class="note-name">
            <h2><%= @new_note.title %>&nbsp;</h2><button class="edit" phx-click="edit-title">[edit]</button>
          </div>
        <% end %>
        <span class="last-saved">Last Saved: <%= @new_note.updated_at %></span>
      </div>
      <div class="editor">
        <div class="input">
          <%= live_component @socket, Component.Monaco, id: "monaco", raw_md: @content %>
        </div>
        <div class="output">
          <%= live_component @socket, Component.MarkdownPreview, md: @md %>
        </div>
      </div>
    </div>
    """
  end
end
