defmodule NitrogenWeb.Component.Navigation do
  use Surface.Component
  alias Surface.Components.LivePatch
  alias NitrogenWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <nav>
        <h2 class="title"><LivePatch to={{ Routes.home_path(@socket, :index) }}>Nitrogen</LivePatch></h2>
        <ul>
          <li><LivePatch to={{ Routes.home_path(@socket, :index, 1) }}>Note 1</LivePatch></li>
        </ul>
    </nav>
    """
  end
end
