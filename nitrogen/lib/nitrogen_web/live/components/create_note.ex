defmodule NitrogenWeb.Component.CreateNote do
  @moduledoc """
  A simple input field for creating notes;
  the prop `id` must be a notebook id.
  """

  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, HiddenInput}
  alias NitrogenWeb.Router.Helpers, as: Routes
  alias Nitrogen.Notes

  def handle_event("submit", %{"new_note" => new_note}, socket) do
    {:ok, note} = Notes.create_note(new_note)
    Notes.PubSub.broadcast_note(:create, note)

    {:noreply, push_redirect(socket, to: Routes.home_path(socket, :index, note.id))}
  end

  def render(assigns) do
    ~H"""
    <Form for={{ :new_note }} submit="submit">
      <TextInput field="title" class="text-black pl-2" opts={{ placeholder: "note name" }} />
      <HiddenInput field="notebook_id" value={{ @id }} />
      <button type="submit" class="ml-2">add</button>
    </Form>
    """
  end
end
