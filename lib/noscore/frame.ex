defprotocol Noscore.Frame do
  @fallback_to_any true
  @spec to_frame(term) :: IO.iodata()
  def to_frame(term)
end

defimpl Noscore.Frame, for: Integer do
  def to_frame(int), do: Integer.to_string(int)
end

defimpl Noscore.Frame, for: Float do
  def to_frame(float), do: Float.to_string(float)
end

defimpl Noscore.Frame, for: BitString do
  def to_frame(""), do: "-"
  def to_frame(bin) when is_binary(bin), do: bin
end

defimpl Noscore.Frame, for: Atom do
  def to_frame(nil) do
    raise ArgumentError, "cannot convert nil to frame"
  end

  def to_frame(atom), do: Atom.to_string(atom)
end

defimpl Noscore.Frame, for: List do
  def to_frame(list) do
    list
    |> Enum.intersperse(" ")
    |> Enum.map(&Noscore.Frame.to_frame/1)
  end
end
