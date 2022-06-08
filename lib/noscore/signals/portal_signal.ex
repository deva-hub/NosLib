defmodule Noscore.PortalSignal do
  @gateway_terminator "-1:-1:-1:10000.10000.1"

  def nstest_frame(signal) do
    [
      "NsTeST",
      signal.key,
      signal.gateways
      |> Enum.map(&gateway/1)
      |> Enum.concat([@gateway_terminator])
    ]
  end

  def gateway(gateway) do
    Enum.join(
      [
        ip_address(gateway.hostname),
        gateway.port,
        gateway_color(gateway),
        gateway_id(gateway)
      ],
      ":"
    )
  end

  defp gateway_id(gateway) do
    Enum.join(
      [
        gateway.world_id,
        gateway.channel_id,
        gateway.world_name
      ],
      "."
    )
  end

  defp gateway_color(gateway) do
    round(gateway.population / gateway.capacity * 20) + 1
  end

  def ip_address({d1, d2, d3, d4}) do
    Enum.join([d1, d2, d3, d4], ".")
  end
end
