defmodule NitrogenWeb.Component.Navigation do
  use Surface.LiveComponent
  alias Surface.Components.{LivePatch, LiveRedirect, Form}
  alias Surface.Components.Form.{Field, TextInput, HiddenInput}
  alias NitrogenWeb.Router.Helpers, as: Routes
  alias NitrogenWeb.Component

  prop notebooks, :list, required: true
  data add_note, :integer, default: 0

  @impl true
  def handle_event("new-note-" <> id, _, %{assigns: %{add_note: add}} = socket) do
    case String.to_integer(id) do
      ^add -> {:noreply, assign(socket, add_note: 0)}
      n -> {:noreply, assign(socket, add_note: n)}
    end
  end

  def handle_event("submit", %{"new_note" => new_note}, socket) do
    {:ok, note} = Nitrogen.Notes.create_note(new_note)
    Nitrogen.Notes.PubSub.broadcast_note(:create, note)

    {:noreply, push_redirect(socket, to: Routes.home_path(socket, :index, note.id))}
  end

  def update(assigns, socket) do
    notebooks =
      assigns.notebooks
      |> Enum.sort_by(& &1.name)
      |> Enum.map(fn notebook ->
        notes = Enum.sort_by(notebook.notes, &String.downcase(&1.title))
        %{notebook | notes: notes}
      end)

    {:ok, assign(socket, notebooks: notebooks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="overflow-y-auto overflow-x-hidden pt-2 px-4 bg-surface shadow-r-md relative">
        <h2 class="text-4xl text-primary-variant font-bold text-center"><LiveRedirect to={{ Routes.home_path(@socket, :index) }}>Nitrogen</LiveRedirect></h2>
        <ul class="flex flex-col py-4 space-y-1" :for={{ item <- @notebooks }} phx-hook="StealFocus" id={{"notebook-#{item.id}"}}>
          <li class="nav-header w-60">
            {{ item.name }}
            <button class="text-sm text-secondary ml-2 plus" :on-click={{ "new-note-#{item.id}" }}>➕</button>
          </li>
          <li class="nav-item" :for={{ note <- item.notes }}>
            <LiveRedirect to={{ Routes.home_path(@socket, :index, note.id) }}>{{ note.title }}</LiveRedirect>
          </li>
          <li class="nav-new-item whitespace-nowrap " :if={{ @add_note == item.id }}>
            <Form for={{ :new_note }} submit="submit">
              <TextInput field="title" class="text-black pl-2" opts={{ placeholder: "note name" }} />
              <HiddenInput field="notebook_id" value={{ item.id }} />
              <button type="submit" class="ml-2">add</button>
            </Form>
          </li>
        </ul>
        <footer class="bottom-0 left-0 p-4 sticky flex flex-column z-10 justify-around">
          <Component.NewNote id="new-note" />
          <div class="nav-header rounded-md shadow-md w-5/6 bg-secondary flex px-2 justify-center">
            <button class="text-black">new notebook</button>
          </div>
        </footer>
    </nav>
    """
  end
end
