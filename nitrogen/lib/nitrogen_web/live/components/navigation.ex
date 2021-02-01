defmodule NitrogenWeb.Component.Navigation do
  use Surface.LiveComponent
  alias Surface.Components.LivePatch
  alias NitrogenWeb.Router.Helpers, as: Routes
  alias NitrogenWeb.Component

  prop notebooks, :list, required: true

  @impl true
  def handle_event("add-notebook", _, socket) do
    Component.NewNotebook.show("dialog")
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="overflow-y-auto overflow-x-hidden pl-4 pt-2 rounded-r-md bg-green-600 bg-opacity-50 shadow-r-md relative">
        <header class="top-0 right-0 absolute">
        </header>
        <h2 class="text-4xl"><LivePatch to={{ Routes.home_path(@socket, :index) }}>Nitrogen</LivePatch></h2>
        <ul class="flex flex-col py-4 space-y-1" :for={{ item <- @notebooks }}>
          <li class="nav-header">
            {{ item.name }}
          </li>
          <li class="nav-item" :for={{ note <- item.notes }}>
            <LivePatch to={{ Routes.home_path(@socket, :index, note.id) }}>{{ note.title }}</LivePatch>
          </li>
        </ul>
        <ul>
          <li class="nav-header rounded-md shadow-md w-5/6 bg-green-500 flex px-2 justify-center">
            <Component.NewNotebook id="dialog" />
            <button :on-click="add-notebook">add new notebook</button>
          </li>
        </ul>
        <footer class="bottom-0 left-0 p-4 absolute flex flex-column justify-around w-full">
          <div>Y</div>
          <div>E</div>
          <div>E</div>
          <div>T</div>
        </footer>
    </nav>
    """
  end
end
