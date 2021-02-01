defmodule NitrogenWeb.Component.MarkdownPreview do
  use Surface.Component

  prop md, :string, default: ""

  def render(assigns) do
    ~H"""
    <div id="markdown-preview" class="markdown" phx-hook="Prism">{{ raw @md }}</div>
    """
  end
end
