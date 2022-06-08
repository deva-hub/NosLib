defmodule Noscore.SignalHelpers do
  def to_frame(true), do: Noscore.Frame.to_frame(1)
  def to_frame(false), do: Noscore.Frame.to_frame(0)
  def to_frame(frame), do: Noscore.Frame.to_frame(frame)
end
