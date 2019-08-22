defmodule NosLib.AuthenticationSerializer do
  @moduledoc """
  Authentification response serializer.
  """

  import NosLib.SerializerUtil

  @type landing_zone :: %{
          world_id: pos_integer,
          world_name: String.t(),
          channel_id: pos_integer,
          ip: String.t(),
          port: pos_integer,
          population: pos_integer,
          capacity: pos_integer
        }

  @type authenticated :: %{
          client_id: pos_integer,
          landing_zones: [landing_zone]
        }

  @spec render(:authenticated, authenticated) :: [String.t()]
  def render(:authenticated, param) do
    [
      serialize_authenticate(param)
    ]
  end

  @spec serialize_authenticate(authenticated) :: String.t()
  defp serialize_authenticate(param) do
    serialize_params([
      "NsTeST",
      param.client_id,
      serialize_landing_zones(param.landing_zones)
    ])
  end

  @spec serialize_landing_zones([landing_zone]) :: String.t()
  defp serialize_landing_zones(landing_zones) do
    landing_zones = Enum.map(landing_zones, &serialize_landing_zone(&1))

    ["-1:-1:-1:10000.10000.1" | landing_zones]
    |> Enum.reverse()
    |> serialize_params()
  end

  @spec serialize_landing_zone(landing_zone) :: String.t()
  defp serialize_landing_zone(landing_zone) do
    serialize_structure([
      serialize_landing_world(landing_zone),
      landing_zone.channel_id,
      normalize_name(landing_zone.world_name)
    ])
  end

  @spec serialize_landing_world(landing_zone) :: String.t()
  defp serialize_landing_world(landing_zone) do
    serialize_status([
      landing_zone.ip,
      landing_zone.port,
      capacity_level(landing_zone.population, landing_zone.capacity),
      landing_zone.world_id
    ])
  end

  @spec serialize_status([String.t()]) :: String.t()
  defp serialize_status(list) do
    Enum.join(list, ":")
  end

  @spec capacity_level(non_neg_integer, non_neg_integer) :: float
  defp capacity_level(current, limit) do
    trunc(round(current / limit * 20) + 1)
  end
end
