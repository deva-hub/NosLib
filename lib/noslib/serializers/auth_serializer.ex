defmodule NosLib.AuthSerializer do
  @moduledoc """
  Authentification response serializer.
  """
  import NosLib.Packet

  @type channel :: %{
          id: pos_integer,
          slot: pos_integer,
          ip: binary,
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

  @spec marshal(:authenticated, authenticated) :: [binary]
  def marshal(:authenticated, param),
    do: [serialize_authenticate(param)]

  defp serialize_authenticate(param) do
    assemble([
      "NsTeST",
      param.session_id,
      serialize_worlds(param.worlds)
    ])
  end

  defp serialize_worlds(worlds) do
    assemble(
      worlds,
      @worlds_ending,
      &serialize_world(&1)
    )
  end

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

  defp serialize_channel_color(population, capacity),
    do: round(population / capacity * 20) + 1
end
