defmodule Noscore.Event.Portal do
  import Noscore.Event.Helpers

  @gateway_terminator "-1:-1:-1:10000.10000.1"

  def nstest_event(event) do
    nslist([
      nsstring("NsTeST"),
      nsint(event.key),
      event.gateways
      |> Enum.map(&gateway/1)
      |> Enum.concat([@gateway_terminator])
      |> nslist()
    ])
  end

  def gateway(gateway) do
    nstuple([
      ip_address(gateway.hostname),
      nsint(gateway.port),
      nsint(gateway_color(gateway.population, gateway.capacity)),
      nsstruct([
        nsint(gateway.world_id),
        nsint(gateway.channel_id),
        nsstring(gateway.world_name)
      ])
    ])
  end

  defp gateway_color(population, capacity) do
    round(population / capacity * 20) + 1
  end

  def ip_address({d1, d2, d3, d4}) do
    nsstruct([nsint(d1), nsint(d2), nsint(d3), nsint(d4)])
  end
end
