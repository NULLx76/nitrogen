defmodule NitrogenWeb.Component.MarkdownPreview do
  use NitrogenWeb, :live_component

  def render(assigns) do
    ~L"""
    <div id="markdown-preview" class="markdown" phx-hook="Prism"><%= raw @md %></div>
    """
  end
end
