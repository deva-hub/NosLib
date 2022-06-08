defmodule Noscore.PortalSignal do
  import Noscore.SignalHelpers

  @gateway_terminator "-1:-1:-1:10000.10000.1"

  def nstest_frame(signal) do
    to_frame([
      to_frame("NsTeST"),
      to_frame(signal.key),
      signal.gateways
      |> Enum.map(&gateway/1)
      |> Enum.concat([@gateway_terminator])
      |> to_frame()
    ])
  end

  def gateway(gateway) do
    Enum.intersperse(
      [
        ip_address(gateway.hostname),
        to_frame(gateway.port),
        to_frame(gateway_color(gateway.population, gateway.capacity)),
        Enum.intersperse(
          [
            to_frame(gateway.world_id),
            to_frame(gateway.channel_id),
            to_frame(gateway.world_name)
          ],
          "."
        )
      ],
      ":"
    )
  end

  defp gateway_color(population, capacity) do
    round(population / capacity * 20) + 1
  end

  def ip_address({d1, d2, d3, d4}) do
    Enum.intersperse([to_frame(d1), to_frame(d2), to_frame(d3), to_frame(d4)], ".")
  end
end
