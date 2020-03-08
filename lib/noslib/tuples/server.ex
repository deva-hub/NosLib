defmodule NosLib.Server do
  @moduledoc """
  Server is the response to a Ping session_id.

  ```
  **Server** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  import NosLib.Helpers
  alias NosLib.{Ip, World}

  @type population :: non_neg_integer
  @type capacity :: non_neg_integer
  @type t :: {:inet.ip4_address(), :inet.port_number(), population, capacity, World.t()}

  @empty "#{Ip.encode()}:-1:-1:#{World.encode()}"

  @spec decode(t) :: iodata
  def decode(@empty) do
    {nil, nil, nil, nil, nil}
  end

  @spec encode(t) :: iodata
  def encode do
    @empty
  end

  def encode({ip, port, population, capacity, world}) do
    [
      ip |> Ip.encode() |> encode_struct(),
      port |> to_string(),
      world_taint(population, capacity) |> to_string(),
      world |> World.encode()
    ]
  end

  defp world_taint(population, capacity) do
    round(population / capacity * 20) + 1
  end
end
