defmodule NitrogenWeb.HomeLive do
  use NitrogenWeb, :live_view
  alias NitrogenWeb.Component
  alias Nitrogen.User

  @doc "The logged in user"
  data user, :map

  @doc "The currenly active note, or 0 for none"
  data note_id, :integer, default: 0

  @impl true
  def handle_params(%{"id" => id}, _session, socket) do
    {:noreply, assign(socket, :note_id, String.to_integer(id))}
  end

  @impl true
  def handle_params(_params, _session, socket) do
    {:noreply, assign(socket, :note_id, 0)}
  end

  @doc """
  If a notebook update is received, update our internal data
  """
  @impl true
  def handle_info({:notebook, :update, nb}, socket) do
    notebooks = Enum.map(socket.assigns.user.notebooks, &if(&1.id == nb.id, do: nb, else: &1))

    {:noreply, assign(socket, user: %User{socket.assigns.user | notebooks: notebooks})}
  end

  @impl true
  def mount(_params, %{"user" => user}, socket) do
    user = User.get_user_and_notes!(user.id)

    for nb <- user.notebooks do
      Nitrogen.Notes.PubSub.subscribe_notebook(nb.id)
    end

    {:ok, assign(socket, user: user)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="grid h-full grid-rows-1" style="grid-template-columns: max-content 1fr">
      <Component.Navigation id="nav" current_note={{@note_id}} notebooks={{ @user.notebooks }}/>

      <div class="h-screen" :if={{@note_id > 0}}>
        <NitrogenWeb.NoteLive id="content-editor" session={{ %{"note_id" => @note_id} }} />
      </div>

      <div class="w-full" :if={{@note_id == 0}}>
        <Component.GraphGrid notebooks={{ @user.notebooks }} />
      </div>
    </div>
    """
  end
end
