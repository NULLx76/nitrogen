defmodule NitrogenWeb.PageController do
  use NitrogenWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
