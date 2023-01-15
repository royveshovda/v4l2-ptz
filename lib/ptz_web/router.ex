defmodule PtzWeb.Router do
  use PtzWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PtzWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PtzWeb do
    pipe_through :browser

    live "/", OverviewLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", PtzWeb do
  #   pipe_through :api
  # end
end
