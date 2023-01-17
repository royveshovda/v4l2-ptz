defmodule Ptz.Positions do
  use GenServer

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def add_position(position) do
    GenServer.call(__MODULE__, {:add_position, position})
  end

  def remove_position(position) do
    GenServer.call(__MODULE__, {:remove_position, position})
  end

  def get_positions do
    GenServer.call(__MODULE__, :get_positions)
  end

  def save_positions do
    GenServer.call(__MODULE__, :save_positions)
  end

  def init(_) do
    positions_filename = Application.get_env(:ptz, :positions_file) |> Path.expand()
    Logger.info(positions_filename)

    positions = get_positions_from_file(positions_filename)

    state = %{
        positions_filename: positions_filename,
        positions: positions
      }

    {:ok, state}
  end

  def handle_call({:add_position, position}, _from, state) do
    {:reply, :ok, %{state | positions: [position | state.positions]}}
  end

  def handle_call({:remove_position, position}, _from, state) do
    {:reply, :ok, %{state | positions: Enum.filter(state.positions, fn x -> x.name != position.name end)}}
  end

  def handle_call(:get_positions, _from, state) do
    {:reply, state.positions, state}
  end

  def handle_call(:save_positions, _from, state) do
    # Save positions to file
    File.write!(state.positions_filename, Jason.encode!(state.positions))
    {:reply, :ok, state}
  end

  defp get_positions_from_file(filename) do
    case File.exists?(filename) do
      true ->
        Logger.info("File exists")

        File.read!(filename)
        |> Jason.decode!(keys: :atoms)
        # |> Enum.map(fn x ->
        #     for {key, val} <- x, into: %{} do
        #       {String.to_atom(key), val}
        #     end
        #   end)
        |> Enum.map(fn x -> struct(Ptz.Position, x) end)
      false ->
        Logger.info("File does not exist")
        []
    end
  end
end
