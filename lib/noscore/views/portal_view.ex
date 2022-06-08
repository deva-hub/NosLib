defmodule Noscore.PortalView do
  use Noscore.Signal

  @gateway_terminator "-1:-1:-1:10000.10000.1"

  def render("nstest.nostale", %{nstest: nstest}) do
    [
      "NsTeST",
      nstest.key,
      render_many(nstest.gateways, PortalView, "gateway.nostale"),
      @gateway_terminator
    ]
  end

  def render("gateway.nostale", %{gateway: gateway}) do
    Enum.join(
      [
        render_one(gateway.hostname, PortalView, "ip_address.nostale"),
        gateway.port,
        render_one(gateway, PortalView, "gateway_color.nostale"),
        render_one(gateway, PortalView, "gateway_id.nostale")
      ],
      ":"
    )
  end

  def render("gateway_id.nostale", %{gateway: gateway}) do
    Enum.join(
      [
        gateway.world_id,
        gateway.channel_id,
        gateway.world_name
      ],
      "."
    )
  end

  def render("gateway_color.nostale", %{gateway: gateway}) do
    round(gateway.population / gateway.capacity * 20) + 1
  end

  def render("ip_address.nostale", {d1, d2, d3, d4}) do
    Enum.join([d1, d2, d3, d4], ".")
  end
end
