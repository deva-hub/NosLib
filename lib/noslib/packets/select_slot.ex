defmodule NosLib.SelectSlot do
  @moduledoc """
  SelectSlot is the response to a Ping message.

  ```
  **SelectSlot** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{
          index: non_neg_integer
        }

  defstruct [:index]

  def deserialize([index]) do
    %__MODULE__{index: index |> String.to_integer()}
  end
end

defimpl NosLib.Encoder, for: NosLib.SelectSlot do
  def serialize(packet) do
    ["select", packet.index]
  end
end
