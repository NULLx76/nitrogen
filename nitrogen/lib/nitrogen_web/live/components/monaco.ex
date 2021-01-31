defmodule NitrogenWeb.Component.Monaco do
  use NitrogenWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="monaco-editor" phx-hook="MonacoEditor" data-raw="<%= @raw_md %>"></div>
    """
  end
end
