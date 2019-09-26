defmodule NosLib.CharDELDecoder do
  @moduledoc """
  Delete an existing character in the lobby.
  """

  @type t :: %{
          optional(:slot) => non_neg_integer,
          optional(:name) => bitstring
        }

  @index_fields [0, 1]

  @spec decode(iodata) :: t
  def decode(packet) when length(packet) == 2 do
    for {v, i} <- Enum.with_index(packet), i in @index_fields, into: %{} do
      case i do
        0 -> {:slot, String.to_integer(v)}
        1 -> {:name, v}
      end
    end
  end

  def decode(_packet),
    do: %{}
end
