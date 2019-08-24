defmodule NosLib.AuthSerializer do
  @moduledoc """
  Authentification response serializer.
  """
  import NosLib.Packet

  @type landing_zone :: %{
          world_id: pos_integer,
          channel_id: pos_integer,
          ip: String.t(),
          port: pos_integer,
          population: pos_integer,
          capacity: pos_integer
        }

  @type authenticated :: %{
          session_id: pos_integer,
          landing_zones: [landing_zone]
        }

  @landing_zones_ending "-1:-1:-1:10000.10000.1"

  @spec render(:authenticated, authenticated) :: [String.t()]
  def render(:authenticated, param) do
    [serialize_authenticate(param)]
  end

  @spec serialize_authenticate(authenticated) :: String.t()
  defp serialize_authenticate(param) do
    assemble([
      "NsTeST",
      param.session_id,
      serialize_landing_zones(param.landing_zones)
    ])
  end

  @spec serialize_landing_zones([landing_zone]) :: String.t()
  defp serialize_landing_zones(landing_zones) do
    assemble(
      Enum.with_index(landing_zones),
      @landing_zones_ending,
      &serialize_landing_zone(&1)
    )
  end

  @spec serialize_landing_zone({landing_zone, integer}) :: String.t()
  defp serialize_landing_zone({landing_zone, index}) do
    link([
      landing_zone.ip,
      landing_zone.port,
      serialize_channel_color(landing_zone.population, landing_zone.capacity),
      flatten([
        index,
        landing_zone.channel_id,
        landing_zone.world_id
      ])
    ])
  end

  defp serialize_channel_color(population, capacity) do
    Integer.to_string(round(population / capacity * 20) + 1)
  end
end
