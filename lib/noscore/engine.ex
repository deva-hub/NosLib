defmodule Noscore.Engine do
  def encode_to_iodata!(other), do: Noscore.Frame.to_iodata(other)
end

defprotocol Noscore.Frame do
  @fallback_to_any true
  @spec to_iodata(term) :: IO.iodata()
  def to_iodata(term)
end

defimpl Noscore.Frame, for: Integer do
  def to_iodata(int), do: Integer.to_string(int)
end

defimpl Noscore.Frame, for: Float do
  def to_iodata(float), do: Float.to_string(float)
end

defimpl Noscore.Frame, for: BitString do
  def to_iodata(""), do: "-"
  def to_iodata(bin) when is_binary(bin), do: bin
end

defimpl Noscore.Frame, for: Atom do
  def to_iodata(nil) do
    raise ArgumentError, "cannot convert nil to frame"
  end

  def to_iodata(atom), do: Atom.to_string(atom)
end

defimpl Noscore.Frame, for: List do
  def to_iodata(list) do
    list
    |> Enum.intersperse(" ")
    |> Enum.map(&Noscore.Frame.to_iodata/1)
  end
end
