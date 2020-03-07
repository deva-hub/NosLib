defmodule Noslib.OkMessage do
  @moduledoc """
  OkMessage is the response to a Ping message.

  ```
  **OkMessage** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  @type t :: %__MODULE__{}

  defstruct []

  def deserialize([]) do
    %__MODULE__{}
  end
end

defimpl Noslib.Encoder, for: Noslib.OkMessage do
  def serialize(%__MODULE__{}) do
    ["OK"]
  end
end
