defmodule NitrogenWeb.NavigationComponent do
  use NitrogenWeb, :live_component

  def render(assigns) do
    ~L"""
    <nav>
        <h2 class="title"><%= live_patch "Nitrogen", to: Routes.home_path(@socket, :index) %></h2>
        <ul>
          <li><%= live_patch "Note 1", to: Routes.home_path(@socket, :index, 1) %></li>
          <li><%= live_patch "Note 1", to: Routes.home_path(@socket, :index, 1) %></li>
          <li><%= live_patch "Note 1", to: Routes.home_path(@socket, :index, 1) %></li>
          <li><%= live_patch "Note 1", to: Routes.home_path(@socket, :index, 1) %></li>
          <li><%= live_patch "Note 1", to: Routes.home_path(@socket, :index, 1) %></li>
        </ul>
    </nav>
    """
  end
end
