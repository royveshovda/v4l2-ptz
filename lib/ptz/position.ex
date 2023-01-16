defmodule Ptz.Position do

  @derive Jason.Encoder
  defstruct name: "Unknown", pan: 0, tilt: 0, zoom: 0
end
