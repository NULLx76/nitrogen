defmodule NitrogenWeb.NoteLive do
  use Surface.LiveView
  alias Surface.Components.Form
  alias Surface.Components.Form.TextInput
  alias Nitrogen.Notes.{Note, Notebook}
  alias Nitrogen.Notes
  alias NitrogenWeb.Component
  alias NitrogenWeb.Router.Helpers, as: Routes

  data note, :any
  data new_note, :any
  data notebook, :any
  data md, :string, default: ""
  data edit_title, :boolean, default: false
  data show_md, :boolean, default: true

  defp save_note(%Note{} = new_note) do
    Notes.PubSub.broadcast_note(:update, new_note)
    new_note
  end

  @impl true
  def handle_event("update", %{"value" => raw}, socket) do
    new_note = save_note(%Note{socket.assigns.new_note | content: raw})
    {md, _} = Notes.render_note(new_note, socket.assigns.notebook)

    {:noreply, assign(socket, new_note: new_note, md: md)}
  end

  def handle_event("edit-title", _params, socket) do
    {:noreply, assign(socket, edit_title: true)}
  end

  def handle_event("save-title", %{"title" => title}, socket) do
    # TODO: Handle state from the watchdog
    {:ok, new_note} = Notes.update_note(socket.assigns.note, %{title: title})
    {:noreply, assign(socket, new_note: save_note(new_note), edit_title: false)}
  end

  def handle_event("toggle-md", _, socket) do
    {:noreply, assign(socket, show_md: !socket.assigns.show_md)}
  end

  @impl true
  def handle_info({:notebook, :update, nb}, socket) do
    {:noreply, assign(socket, notebook: nb)}
  end

  @impl true
  def terminate(_reason, %{assigns: %{new_note: note}}) do
    save_note(note)
    :ok
  end

  def mount(_params, %{"note_id" => id}, socket) do
    note = Notes.get_note!(id)
    nb = Notes.get_notebook!(note.notebook_id) |> Nitrogen.Repo.preload(:notes)
    {md, _} = Notes.render_note(note, nb)

    Nitrogen.Notes.PubSub.subscribe_notebook(nb.id)

    {:ok, assign(socket, note: note, notebook: nb, new_note: note, md: md),
     temporary_assigns: [initial_content: note.content]}
  end
end
