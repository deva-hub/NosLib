defmodule NosLib.SlotStream do
  @moduledoc """
  SlotStream is used to stream the character list.
  """

  @type t :: %__MODULE__{
          length: non_neg_integer
        }

  defstruct length: 0

  def deserialize([length]) do
    %__MODULE__{length: length}
  end
end

defimpl NosLib.Encoder, for: NosLib.SlotStream do
  def serialize(packet) do
    ["clist_start", packet.length]
  end
end
