defmodule NosLib do
  @moduledoc """
  NosLib keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  import NosLib.Helpers

  @spec serialize(struct) :: iodata
  def serialize(packet) when is_binary(packet) do
    packet
    |> NosLib.Encoder.serialize()
    |> encode_packet()
  end

  @spec deserialize(binary) :: iodata
  def deserialize(packet) when is_binary(packet) do
    packet
    |> decode_packet()
    |> NosLib.Encoder.deserialize()
  end
end
