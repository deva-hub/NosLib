defmodule NosLib.AuthSerializer do
  @moduledoc """
  Authentification response serializer.
  """
  import NosLib.Packet

  @type channel :: %{
          id: pos_integer,
          slot: pos_integer,
          ip: String.t(),
          port: pos_integer,
          population: pos_integer,
          capacity: pos_integer
        }

  @type world :: %{
          id: pos_integer,
          channels: [channel]
        }

  @type authenticated :: %{
          session_id: pos_integer,
          worlds: [world]
        }

  @worlds_ending "-1:-1:-1:10000.10000.1"

  @spec render(:authenticated, authenticated) :: [String.t()]
  def render(:authenticated, param) do
    [serialize_authenticate(param)]
  end

  @spec serialize_authenticate(authenticated) :: String.t()
  defp serialize_authenticate(param) do
    assemble([
      "NsTeST",
      param.session_id,
      serialize_worlds(param.worlds)
    ])
  end

  @spec serialize_worlds([world]) :: String.t()
  defp serialize_worlds(worlds) do
    assemble(
      worlds,
      @worlds_ending,
      &(serialize_world(&1))
    )
  end

  @spec serialize_world(world) :: String.t()
  defp serialize_world(world) do
    Enum.map(world.channels, fn channel ->
      link([
        channel.ip,
        channel.port,
        serialize_channel_color(channel.population, channel.capacity),
        flatten([
          channel.slot,
          channel.id,
          world.id
        ])
      ])
    end)
  end

  defp serialize_channel_color(population, capacity) do
    Integer.to_string(round(population / capacity * 20) + 1)
  end
end
