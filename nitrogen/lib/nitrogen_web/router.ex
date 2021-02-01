defmodule NitrogenWeb.Router do
  use NitrogenWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NitrogenWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fake_login
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NitrogenWeb do
    pipe_through :browser

    live "/", HomeLive, :index
    live "/note/:id", HomeLive, :index
  end

  def fake_login(conn, _opts) do
    user = Nitrogen.User.get_user!(1)
    put_session(conn, :user, user)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NitrogenWeb.Telemetry
    end
  end
end
