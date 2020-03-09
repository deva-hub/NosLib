defmodule NosLib.OkMessage do
  @moduledoc """
  OkMessage is a simple ping response.
  """

  @type t :: %__MODULE__{}

  defstruct []

  def deserialize([]) do
    %__MODULE__{}
  end
end

defimpl NosLib.Encoder, for: NosLib.OkMessage do
  def serialize(_) do
    ["OK"]
  end
end
