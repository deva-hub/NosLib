defmodule Noscore.Event.Client do
  import Noscore.Event.Helpers

  def failc_event(event) do
    nslist([nsstring("failc"), error(event.error)])
  end

  def info_event(event) do
    nslist([nsstring("info"), nsstring(event.message)])
  end

  def error(:outdated_client), do: nsint(1)
  def error(:unexpected_error), do: nsint(2)
  def error(:maintenance), do: nsint(3)
  def error(:session_already_used), do: nsint(4)
  def error(:unvalid_credentials), do: nsint(5)
  def error(:cant_authenticate), do: nsint(6)
  def error(:citizen_blacklisted), do: nsint(7)
  def error(:country_blacklisted), do: nsint(8)
  def error(:bad_case), do: nsint(9)

  def lang(:kr), do: nsint(0)
  def lang(:en), do: nsint(1)

  def name_color(:white), do: nsint(0)
  def name_color(:violet), do: nsint(2)
  def name_color(:invisible), do: nsint(6)
end
