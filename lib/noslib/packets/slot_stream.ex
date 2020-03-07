defmodule Noslib.SlotStream do
  @moduledoc """
  SlotStream is the response to a Ping message.

  ```
  **SlotStream** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{
          length: length
        }

  defstruct []

  def deserialize([length]) do
    %__MODULE__{length: length}
  end
end

defimpl Noslib.Encoder, for: Noslib.SlotStream do
  def serialize(packet) do
    ["clist_start", packet.length]
  end
end
