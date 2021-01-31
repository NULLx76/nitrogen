defmodule NitrogenWeb.MonacoComponent do
  use NitrogenWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="monaco-editor" phx-hook="MonacoEditor"></div>
    """
  end
end