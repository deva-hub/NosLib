defmodule NosLib.SlotStream.End do
  @moduledoc """
  SlotStream.End is the response to a Ping message.

  ```
  **SlotStream.End** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{}

  defstruct []

  def deserialize([]) do
    %__MODULE__{}
  end
end

defimpl NosLib.Encoder, for: NosLib.SlotStream.End do
  def serialize(_) do
    ["clist_end"]
  end
end
