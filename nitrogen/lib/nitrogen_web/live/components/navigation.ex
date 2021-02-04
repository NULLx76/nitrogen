defmodule NitrogenWeb.Component.Navigation do
  use Surface.LiveComponent
  alias Surface.Components.{LiveRedirect, Form}
  alias Surface.Components.Form.{TextInput, HiddenInput}
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
      <header>
        <h2 class="text-4xl text-primary-variant font-bold text-center"><LiveRedirect to={{ Routes.home_path(@socket, :index) }}>Nitrogen</LiveRedirect></h2>
      </header>
      <ul class="flex flex-col py-4 space-y-1" :for={{ item <- @notebooks }} phx-hook="StealFocus" id={{"notebook-#{item.id}"}}>
        <li class="nav-header w-60">
          {{ item.name }}
          <button class="text-sm text-secondary ml-2 plus" :on-click={{ "new-note-#{item.id}" }}>➕</button>
        </li>
        <li class="nav-item" :for={{ note <- item.notes }}>
          <LiveRedirect to={{ Routes.home_path(@socket, :index, note.id) }}>{{ note.title }}</LiveRedirect>
        </li>
        <li class="nav-new-item whitespace-nowrap" :if={{ @add_note == item.id }}>
          <Component.CreateNote id={{item.id}} />
        </li>
      </ul>
      <footer class="bottom-0 left-0 p-4 sticky flex flex-column z-10 justify-around">
        <div class="nav-header rounded-md shadow-md w-5/6 bg-secondary flex px-2 justify-center">
          <button class="text-black">new notebook</button>
        </div>
      </footer>
    </nav>
    """
  end
end
