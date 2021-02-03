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
  def handle_info({:note, :update, %Note{} = note}, state) do
    state =
      Map.update(state, note.notebook_id, Notes.get_notebook!(note.notebook_id), fn current ->
        notes = Enum.map(current.notes, &if(&1.id == note.id, do: note, else: &1))
        %Notebook{current | notes: notes}
      end)

    PubSub.broadcast_notebook(:update, Map.fetch!(state, note.notebook_id))

    {:noreply, state}
  end

  @impl true
  def handle_info({:notebook, :update, %Notebook{} = nb}, state) do
    IO.inspect(nb)
    {:noreply, state}
  end
end