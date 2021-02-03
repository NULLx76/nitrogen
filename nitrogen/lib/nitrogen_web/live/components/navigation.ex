defmodule NitrogenWeb.Component.Navigation do
  use Surface.LiveComponent
  alias Surface.Components.{LivePatch, LiveRedirect}
  alias NitrogenWeb.Router.Helpers, as: Routes
  alias NitrogenWeb.Component

  prop notebooks, :list, required: true

  @impl true
  def handle_event("add-note", _, socket) do
    Component.NewNote.show("new-note")
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <nav class="overflow-y-auto overflow-x-hidden pt-2 px-4 bg-surface shadow-r-md relative ">
        <h2 class="text-4xl text-primary font-bold text-center"><LivePatch to={{ Routes.home_path(@socket, :index) }}>Nitrogen</LivePatch></h2>
        <ul class="flex flex-col py-4 space-y-1" :for={{ item <- @notebooks }}>
          <li class="nav-header">
            {{ item.name }}
          </li>
          <li class="nav-item" :for={{ note <- item.notes }}>
            <LiveRedirect to={{ Routes.home_path(@socket, :index, note.id) }}>{{ note.title }}</LiveRedirect>
          </li>
        </ul>
        <footer class="bottom-0 left-0 p-4 sticky flex flex-column z-10 justify-around">
          <Component.NewNote id="new-note" />
          <div class="nav-header rounded-md shadow-md w-5/6 bg-secondary flex px-2 justify-center">
            <button class="text-black" :on-click="add-note">new notebook</button>
          </div>
        </footer>
    </nav>
    """
  end
end
