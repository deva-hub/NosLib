defmodule NosLib.SelectPacket do
  @moduledoc """
  Select character in the lobby.
  """

  @type packet :: %{
          optional(slot) => non_neg_integer
        }

  @spec unmarshal(binary) :: packet
  def unmarshal(packet) when length(packet) === 1 do
    packet
    |> Enum.with_index()
    |> Enum.reduce(%{}, &unmarshal_field/2)
  end

  def unmarshal(_packet),
    do: %{}

  def unmarshal_field({value, 0}, acc),
    do: Map.put(acc, :slot, value)

  def unmarshal_field(_element, acc),
    do: acc
end
