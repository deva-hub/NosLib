defmodule NosLib.SlotStream.End do
  @moduledoc """
  End is the packet used to close the stream.
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
