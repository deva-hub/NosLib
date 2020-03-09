defmodule NosLib.Ip do
  @type t :: :inet.ip4_address()

  @empty ["-1"]

  def decode(@empty) do
    {0, 0, 0, 0}
  end

  def decode([d1, d2, d3, d4]) do
    {
      d1 |> String.to_integer(),
      d2 |> String.to_integer(),
      d3 |> String.to_integer(),
      d4 |> String.to_integer()
    }
  end

  @spec encode(t) :: iodata
  def encode do
    @empty
  end

  def encode({d1, d2, d3, d4}) do
    {
      d1 |> to_string(),
      d2 |> to_string(),
      d3 |> to_string(),
      d4 |> to_string()
    }
  end
end
