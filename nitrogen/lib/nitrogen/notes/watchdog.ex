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
      |> Map.put(:to_update, %{})

    schedule_save()

    {:ok, state}
  end

  defp schedule_save do
    Process.send_after(self(), :save, 5 * 1000)
  end

  # Insert {old_note, new_note} into :to_update of the state
  defp update_to_update(state, new_note) do
    old_note =
      case get_in(state, [:to_update, new_note.id]) do
        nil -> %Note{id: new_note.id}
        some -> elem(some, 0)
      end

    put_in(state, [:to_update, new_note.id], {old_note, new_note})
  end

  @impl true
  def handle_info({:note, action, %Note{} = note}, state) when action in [:update, :create] do
    state =
      update_to_update(state, note)
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

  def handle_info({:notebook, :update, %Notebook{} = nb}, state) do
    state = Map.put(state, nb.id, Repo.preload(nb, :notes))
    {:noreply, state}
  end

  def handle_info(:save, state) do
    to_update =
      Map.fetch!(state, :to_update)
      |> Enum.map(fn {id, {old, new}} ->
        {:ok, new} = Notes.update_note(old, Map.from_struct(new))
        {id, {new, new}}
      end)
      |> Enum.into(%{})

    schedule_save()
    {:noreply, Map.put(state, :to_update, to_update)}
  end
end
