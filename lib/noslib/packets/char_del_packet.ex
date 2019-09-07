defmodule NosLib.CharDELPacket do
  @moduledoc """
  Delete an existing character in the lobby.
  """

  @type packet :: %{
          optional(slot) => non_neg_integer,
          optional(name) => binary
        }

  @spec unmarshal(binary) :: packet
  def unmarshal(packet) when length(packet) === 2 do
    packet
    |> Enum.with_index()
    |> Enum.reduce(%{}, &unmarshal_field/2)
  end

  def unmarshal(_packet),
    do: %{}

  def unmarshal_field({value, 0}, acc),
    do: Map.put(acc, :slot, String.to_integer(value))

  def unmarshal_field({value, 1}, acc),
    do: Map.put(acc, :name, value)

  def unmarshal_field(_element, acc),
    do: acc
end
