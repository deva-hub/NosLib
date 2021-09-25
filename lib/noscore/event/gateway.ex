defmodule Noscore.Event.Gateway do
  import Noscore.Event.Helpers

  @portal_terminator "-1:-1:-1:10000.10000.1"

  def nstest_event(event) do
    nslist([
      nsstring("nstest"),
      nsint(event.key),
      event.portals
      |> Enum.map(&portal/1)
      |> Enum.concat([@portal_terminator])
      |> nslist()
    ])
  end

  def portal(portal) do
    nstuple([
      ip_address(portal.hostname),
      nsint(portal.port),
      nsint(portal_color(portal.population, portal.capacity)),
      nsstruct([
        nsint(portal.world_id),
        nsint(portal.channel_id),
        nsstring(portal.world_name)
      ])
    ])
  end

  defp portal_color(population, capacity) do
    round(population / capacity * 20) + 1
  end

  def ip_address({d1, d2, d3, d4}) do
    nsstruct([nsint(d1), nsint(d2), nsint(d3), nsint(d4)])
  end
end
