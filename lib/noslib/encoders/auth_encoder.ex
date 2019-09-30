defmodule NosLib.AuthEncoder do
  @moduledoc """
  Authentification response serializer.
  """

  @type channel :: %{
          id: pos_integer,
          slot: pos_integer,
          ip: :inet.ip4_address(),
          port: :inet.port_number(),
          population: non_neg_integer,
          capacity: non_neg_integer
        }

  @type world :: %{
          id: pos_integer,
          channels: [channel]
        }

  @type authenticated :: %{
          session_id: pos_integer,
          worlds: [world]
        }

  @worlds_end "-1:-1:-1:10000.10000.1"

  @spec encode(:authenticated, authenticated) :: [binary]
  def encode(:authenticated, param),
    do: [:binary.list_to_bin(encode_authenticate(param))]

  @spec encode_to_iodata(:authenticated, authenticated) :: [iodata]
  def encode_to_iodata(:authenticated, param),
    do: [encode_authenticate(param)]

  defp encode_authenticate(param) do
    [
      "NsTeST",
      " ",
      Integer.to_string(param.session_id),
      " ",
      encode_worlds(param.worlds)
    ]
  end

  defp encode_worlds(worlds) do
    worlds
    |> Enum.reduce([@worlds_end], &[encode_world(&1) | &2])
    |> Enum.intersperse(" ")
  end

  defp encode_world(world) do
    world.channels
    |> Enum.map(
      &[
        encode_ip_address(&1.ip),
        ":",
        Integer.to_string(&1.port),
        ":",
        encode_channel_color(&1.population, &1.capacity),
        ":",
        Integer.to_string(&1.slot),
        ".",
        Integer.to_string(&1.id),
        ".",
        Integer.to_string(world.id)
      ]
    )
    |> Enum.intersperse(" ")
  end

  defp encode_channel_color(population, capacity),
    do: Integer.to_string(round(population / capacity * 20) + 1)

  defp encode_ip_address({d1, d2, d3, d4}) do
    [
      Integer.to_string(d1),
      ".",
      Integer.to_string(d2),
      ".",
      Integer.to_string(d3),
      ".",
      Integer.to_string(d4)
    ]
  end
end
