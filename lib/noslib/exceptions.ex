defmodule NosLib.CryptoError do
  defexception []

  @impl true
  def message(_exception) do
    "could decode packet"
  end
end

defmodule NosLib.ParserError do
  defexception []

  @impl true
  def message(_exception) do
    "could parse packet"
  end
end
