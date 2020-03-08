defmodule NosLib.DeleteSlot do
  @moduledoc """
  DeleteSlot is the response to a Ping index.

  ```
  **DeleteSlot** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{
          index: non_neg_integer,
          name: String.t()
        }

  defstruct [:index, :name]

  def deserialize([index, name]) do
    %__MODULE__{index: index |> String.to_integer(), name: name}
  end
end

defimpl NosLib.Encoder, for: NosLib.DeleteSlot do
  def serialize(packet) do
    [
      "char_DEL",
      packet.name |> to_string(),
      packet.index |> to_string()
    ]
  end
end
