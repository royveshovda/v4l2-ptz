defmodule PtzWeb.OverviewLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Logger.debug("Web connected")
    end

    positions = Ptz.Positions.get_positions()

    Logger.debug("Positions: #{inspect(positions)}")

    socket =
      socket
      |> assign(positions: positions)
    {:ok, socket}
  end

  @impl true
  def handle_event("go_to_position", %{"position" => position, "pan" => pan, "tilt" => tilt, "zoom" => zoom}, socket) do
    Logger.info("Clicked position: #{position} pan: #{pan} tilt: #{tilt} zoom: #{zoom}")

    Ptz.Cam.move(pan, tilt, zoom)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <h1>Positions:</h1>
        <div class="cards">
          <article class="card">
            <%= for position <- @positions do %>
              <button class="card-button" phx-click="go_to_position" phx-value-pan={position.pan} phx-value-tilt={position.tilt} phx-value-zoom={position.zoom} phx-value-position={position.name} ><%= position.name %></button>
            <% end %>
          </article>
        </div>
      </section>
    """
  end
end
