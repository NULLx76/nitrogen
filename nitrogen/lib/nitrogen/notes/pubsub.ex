defmodule Nitrogen.Notes.PubSub do
  alias Phoenix.PubSub
  alias Nitrogen.Notes.{Note, Notebook}

  @pubsub Nitrogen.PubSub

  @actions [:update, :create]

  # Note Topics
  def note_topic(), do: "#{inspect(__MODULE__)}-note"
  def note_topic(id), do: "#{note_topic()}-#{id}"

  def subscribe_note() do
    PubSub.subscribe(@pubsub, note_topic())
  end

  def subscribe_note(id) do
    PubSub.subscribe(@pubsub, note_topic(id))
  end

  def broadcast_note(event, %Note{id: id} = note) when event in @actions do
    PubSub.broadcast_from(@pubsub, self(), note_topic(), {:note, event, note})
    PubSub.broadcast_from(@pubsub, self(), note_topic(id), {:note, event, note})
  end

  # Notebook topics

  def notebook_topic(), do: "#{inspect(__MODULE__)}-notebook"
  def notebook_topic(id), do: "#{notebook_topic()}-#{id}"

  def subscribe_notebook() do
    PubSub.subscribe(@pubsub, notebook_topic())
  end

  def subscribe_notebook(id) do
    PubSub.subscribe(@pubsub, notebook_topic(id))
  end

  def broadcast_notebook(event, %Notebook{id: id} = nb) when event in @actions do
    PubSub.broadcast_from(@pubsub, self(), notebook_topic(), {:notebook, event, nb})
    PubSub.broadcast_from(@pubsub, self(), notebook_topic(id), {:notebook, event, nb})
  end
end
