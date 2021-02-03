defmodule NitrogenWeb.Component.Monaco do
  use Surface.LiveComponent

  prop raw_md, :string, default: ""

  def render(assigns) do
    ~H"""
    <div id="monaco-editor" phx-hook="MonacoEditor" data-raw="{{ @raw_md }}" phx-update="ignore"></div>
    """
  end
end
