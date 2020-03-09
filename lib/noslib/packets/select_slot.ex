defmodule NosLib.SelectSlot do
  @moduledoc """
  SelectSlot is the used to select the character to load.
  """

  @type t :: %__MODULE__{
          index: non_neg_integer
        }

  defstruct index: 0

  def deserialize([index]) do
    %__MODULE__{index: index |> String.to_integer()}
  end
end

defimpl NosLib.Encoder, for: NosLib.SelectSlot do
  def serialize(packet) do
    ["select", packet.index]
  end
end
