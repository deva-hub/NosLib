defmodule NosLib.InfoMessage do
  @moduledoc """
  InfoMessage is the used to pop an information message to the client.
  """

  @type t :: %__MODULE__{message: String.t()}

  defstruct message: ""

  def deserialize([message]) do
    %__MODULE__{message: message}
  end
end

defimpl NosLib.Encoder, for: NosLib.InfoMessage do
  def serialize(packet) do
    ["info", packet.message]
  end
end
