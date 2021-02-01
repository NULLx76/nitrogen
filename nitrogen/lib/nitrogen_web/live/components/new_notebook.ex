defmodule NitrogenWeb.Component.NewNotebook do
  use Surface.LiveComponent

  data show, :boolean, default: false

  # public api
  def show(dialog_id) do
    send_update(__MODULE__, id: dialog_id, show: true)
  end

  def handle_event("show", _, socket) do
    {:noreply, assign(socket, show: true)}
  end

  def handle_event("hide", _, socket) do
    {:noreply, assign(socket, show: false)}
  end

  def render(assigns) do
    ~H"""
    <div :show={{ @show }}>
    <div class="fixed z-10 inset-0 overflow-y-auto flex justify-center items-center">
      <div class="fixed inset-0 transition-opacity">
        <div class="absolute inset-0 bg-gray-500 opacity-75" :on-click="hide"></div>
      </div>
      <div class="bg-white z-20 text-center py-6 px-12 shadow-md rounded grid grid-cols-2 grid-rows-3 gap-8">
        <h1 class="col-span-full text-2xl font-semibold border-b-2">
          Add new notebook
        </h1>

        <p class="col-span-full">
          a form or something idk
        </p>

        <button :on-click="hide">
          Cancel
        </button>
        <button :on-click="hide">
          Save
        </button>
      </div>
    </div>
    </div>
    """
  end
end
