defmodule Ptz.Cam do
  def move(pan, tilt, zoom) do
    System.cmd("v4l2-ctl", ["-d", "/dev/video0", "-c", "zoom_absolute=#{zoom}", "-c", "pan_absolute=#{pan}", "-c", "tilt_absolute=#{tilt}"])
  end
end
