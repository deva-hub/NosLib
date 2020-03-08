defmodule NosLib.InfoMessage do
  @moduledoc """
  InfoMessage is the response to a Ping message.

  ```
  **InfoMessage** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{message: bitstring}

  defstruct [:message]

  def deserialize([message]) do
    %__MODULE__{message: message}
  end
end

defimpl NosLib.Encoder, for: NosLib.InfoMessage do
  def serialize(packet) do
    ["info", packet.message]
  end
end
