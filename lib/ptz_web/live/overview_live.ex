defmodule PtzWeb.OverviewLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Logger.debug("Web connected")
    end

    socket =
      socket
      #|> assign(deployments: [], nodes: [], pods_metrics: [])
    {:ok, socket}
  end

  @impl true
  def handle_event("go_to_position", %{"position" => position}, socket) do
    Logger.info("Clicked position: #{position}")

    case position do
      "center" -> Ptz.Cam.move(15000, -45000, 100)
      "rodecaster" -> Ptz.Cam.move(220000, -162000, 350)
      "ultimaker" -> Ptz.Cam.move(-180000, 15000, 300)
      "outside" -> Ptz.Cam.move(-270000, 55000, 400)
      _ -> Logger.error("Unknown position: #{position}")
    end


    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <h1>Positions:</h1>
        <div class="cards">
          <article class="card">
            <button class="card-button" phx-click="go_to_position" phx-value-position="center">Center</button>
            <button class="card-button" phx-click="go_to_position" phx-value-position="rodecaster">Rødecaster</button>
            <button class="card-button" phx-click="go_to_position" phx-value-position="ultimaker">Ultimaker</button>
            <button class="card-button" phx-click="go_to_position" phx-value-position="outside">Outside</button>
          </article>
        </div>
      </section>
    """
  end
end
