defmodule Ptz.Positions do
  use GenServer

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    positions_filename = Application.get_env(:ptz, :positions_file)
    Logger.info(positions_filename)

    pos_fake = "[{\"name\":\"center\",\"pan\":15000,\"tilt\":-45000,\"zoom\":100},{\"name\":\"rodecaster\",\"pan\":220000,\"tilt\":-162000,\"zoom\":350}]"

    positions =
      case File.exists?(positions_filename) do
        true ->
          Logger.info("File exists")
          # TODO: Read file and populate state
          []
        false ->
          Logger.info("File does not exist")
          []
      end

    state = %{
        positions_filename: positions_filename,
        positions: positions
      }

    {:ok, state}
  end
end
