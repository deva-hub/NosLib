defmodule Noscore.ClientSignal do
  def failc_frame(signal) do
    ["failc", reason(signal.reason)]
  end

  def info_frame(signal) do
    ["info", signal.content]
  end

  def reason(:outdated_client), do: 1
  def reason(:unexpected_error), do: 2
  def reason(:maintenance), do: 3
  def reason(:session_already_used), do: 4
  def reason(:unvalid_credentials), do: 5
  def reason(:cant_authenticate), do: 6
  def reason(:citizen_blacklisted), do: 7
  def reason(:country_blacklisted), do: 8
  def reason(:bad_case), do: 9

  def lang(:kr), do: 0
  def lang(:en), do: 1

  def name_color(:white), do: 0
  def name_color(:violet), do: 2
  def name_color(:invisible), do: 6
end
