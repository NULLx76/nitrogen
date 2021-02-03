defmodule NitrogenWeb.Component.NewNote do
  use Surface.LiveComponent
  alias Surface.Components.Form
  alias Surface.Components.Form.{TextInput, Label, Field, ErrorTag}

  data show, :boolean, default: false
  data note, :map

  # public api
  def show(dialog_id) do
    send_update(__MODULE__, id: dialog_id, show: true)
  end

  @impl true
  def handle_event("show", _, socket) do
    {:noreply, assign(socket, show: true)}
  end

  def handle_event("hide", _, socket) do
    {:noreply, assign(socket, show: false)}
  end

  def handle_event("change", %{"note" => %{"title" => title}}, socket) do
    note = Ecto.Changeset.change(socket.assigns.note, title: title)
    {:noreply, assign(socket, note: note)}
  end

  @impl true
  def update(assigns, socket) do
    changeset = Nitrogen.Notes.Note.changeset(%Nitrogen.Notes.Note{}, %{})
    socket = assign(socket, assigns)
    {:ok, assign(socket, note: changeset)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div :show={{ @show }}>
    <div class="fixed z-10 inset-0 overflow-y-auto flex justify-center items-center text-black">
      <div class="fixed inset-0 transition-opacity">
        <div class="absolute inset-0 bg-gray-500 opacity-75" :on-click="hide"></div>
      </div>
      <div class="bg-white z-20 text-center py-6 px-12 shadow-md rounded grid grid-cols-2 grid-rows-3 gap-8">
        <h1 class="col-span-full text-2xl font-semibold border-b-2">
          Create new note
        </h1>

        <div class="col-span-full">
          <Form for={{ @note }} change="change">
            <Field name="title">
              <Label/>
              <ErrorTag />
              <TextInput form="note" />
            </Field>
          </Form>
        </div>

        <button :on-click="hide">
          Cancel
        </button>
        <button :on-click="hide">
          Create
        </button>
      </div>
    </div>
    </div>
    """
  end
end
