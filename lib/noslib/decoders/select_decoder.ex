defmodule NosLib.SelectDecoder do
  @moduledoc """
  Select character in the lobby.
  """

  @type t :: %{
          optional(:slot) => non_neg_integer
        }

  @index_fields [0]

  @spec decode(iodata) :: t
  def decode(packet) when length(packet) == 1 do
    for {v, i} <- Enum.with_index(packet), i in @index_fields, into: %{} do
      case i do
        0 -> {:slot, v}
      end
    end
  end

  def decode(_packet),
    do: %{}
end
