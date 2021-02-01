defmodule NitrogenWeb.HomeLive do
  use NitrogenWeb, :live_view
  alias NitrogenWeb.Component
  alias Nitrogen.User
  alias Nitrogen.Notes.Notebook

  @impl true
  def handle_params(%{"id" => id}, _session, socket) do
    {:noreply, assign(socket, :note_id, id)}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply, assign(socket, :note_id, 0)}
  end

  @doc """
  On a `title-update` pubsub event find the relevant note and update it in our notebook list
  """
  @impl true
  def handle_info(%{topic: "title-update", event: _event, payload: new_note}, socket) do
    notebooks =
      socket.assigns.notebooks
      |> Enum.map(fn el ->
        if el.id == new_note.notebook_id do
          notes = Enum.map(el.notes, &if(&1.id == new_note.id, do: new_note))
          %Notebook{el | notes: notes}
        end
      end)

    {:noreply, assign(socket, notebooks: notebooks)}
  end

  @impl true
  def mount(_params, %{"user" => user}, socket) do
    notebooks = User.get_user_and_notes!(user.id).notebooks

    NitrogenWeb.Endpoint.subscribe("title-update")
    {:ok, assign(socket, notebooks: notebooks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-6 grid-rows-1 h-full">
      <Component.Navigation id="nav" notebooks={{ @notebooks }}/>

      <div class="col-span-5 h-screen" :if={{@note_id > 0}}>
        <NitrogenWeb.NoteLive id="content-editor" session={{ %{"note_id" => @note_id} }}  />
      </div>

      <div class="col-span-5" :if={{@note_id == 0}}>
        Lorem Ipsum Doler Sit Amet
        <button class="b-button">button</button>
      </div>
    </div>
    """
  end
end
