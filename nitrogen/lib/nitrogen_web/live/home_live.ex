defmodule NitrogenWeb.HomeLive do
  use NitrogenWeb, :live_view
  alias NitrogenWeb.Component
  alias Nitrogen.User
  alias Nitrogen.Notes.{Note,Notebook}

  @doc "The logged in user"
  data user, :map

  @doc "The currenly active note, or 0 for none"
  data note_id, :integer, default: 0

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
      socket.assigns.user.notebooks
      |> Enum.map(fn el ->
        if el.id == new_note.notebook_id do
          notes = Enum.map(el.notes, &if(&1.id == new_note.id, do: %Note{&1 | title: new_note.title }, else: &1))
          %Notebook{el | notes: notes}
        else
          el
        end
      end)

    {:noreply, assign(socket, user: %User{socket.assigns.user | notebooks: notebooks})}
  end

  @impl true
  def mount(_params, %{"user" => user}, socket) do
    user = User.get_user_and_notes!(user.id)

    NitrogenWeb.Endpoint.subscribe("title-update")
    {:ok, assign(socket, user: user)}
  end


  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-6 grid-rows-1 h-full">
      <Component.Navigation id="nav" notebooks={{ @user.notebooks }}/>

      <div class="col-span-5 h-screen" :if={{@note_id > 0}}>
        <NitrogenWeb.NoteLive id="content-editor" session={{ %{"note_id" => @note_id} }} />
      </div>

      <div class="col-span-5" :if={{@note_id == 0}}>
        <Component.GraphGrid notebooks={{ @user.notebooks }} />
      </div>
    </div>
    """
  end
end
