defmodule NosLib.Ip do
  @type t :: :inet.ip4_address()

  @empty ["-1"]

  def decode(@empty) do
    {0, 0, 0, 0}
  end

  def decode(ip) do
    ip
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @spec encode(t) :: iodata
  def encode do
    @empty
  end

  def encode(ip) do
    ip
    |> Tuple.to_list()
    |> Enum.map(&to_string/1)
  end
end
