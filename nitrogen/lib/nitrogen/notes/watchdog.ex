defmodule Nitrogen.Notes.Watchdog do
  use GenServer
  alias Nitrogen.Notes.{Note, Notebook, PubSub}
  alias Nitrogen.{Repo, Notes}

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: NotesWatchdog)
  end

  @impl true
  def init(:ok) do
    PubSub.subscribe_note()
    PubSub.subscribe_notebook()

    state =
      Notes.list_notebooks()
      |> Repo.preload(:notes)
      |> Map.new(&{&1.id, &1})

    {:ok, state}
  end

  @impl true
  def handle_info({:note, action, %Note{} = note}, state) when action in [:update, :create] do
    state =
      state
      |> Map.put_new_lazy(note.notebook_id, fn ->
        Notes.get_notebook!(note.notebook_id) |> Repo.preload(:notes)
      end)
      |> Map.update!(note.notebook_id, fn current ->
        notes = Enum.reject(current.notes, &(&1.id == note.id))
        %Notebook{current | notes: [note | notes]}
      end)

    PubSub.broadcast_notebook(:update, Map.fetch!(state, note.notebook_id))

    {:noreply, state}
  end

  @impl true
  def handle_info({:notebook, :update, %Notebook{} = nb}, state) do
    state = Map.put(state, nb.id, Repo.preload(nb, :notes))
    {:noreply, state}
  end
end
