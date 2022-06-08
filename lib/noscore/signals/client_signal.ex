defmodule Noscore.ClientSignal do
  import Noscore.SignalHelpers

  def failc_frame(signal) do
    to_frame([to_frame("failc"), error(signal.error)])
  end

  def info_frame(signal) do
    to_frame([to_frame("info"), to_frame(signal.content)])
  end

  def error(:outdated_client), do: to_frame(1)
  def error(:unexpected_error), do: to_frame(2)
  def error(:maintenance), do: to_frame(3)
  def error(:session_already_used), do: to_frame(4)
  def error(:unvalid_credentials), do: to_frame(5)
  def error(:cant_authenticate), do: to_frame(6)
  def error(:citizen_blacklisted), do: to_frame(7)
  def error(:country_blacklisted), do: to_frame(8)
  def error(:bad_case), do: to_frame(9)

  def lang(:kr), do: to_frame(0)
  def lang(:en), do: to_frame(1)

  def name_color(:white), do: to_frame(0)
  def name_color(:violet), do: to_frame(2)
  def name_color(:invisible), do: to_frame(6)
end
