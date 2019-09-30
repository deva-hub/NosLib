defmodule NosLib.LoginCrypto do
  @moduledoc """
  This module provides a set of functions used for decoding and encoding Login
  packets.
  """
  use Bitwise, only_operators: true

  @spec encode(iodata) :: binary
  def encode(input) when is_list(input),
    do: encode(:binary.list_to_bin(input))

  @spec encode(String.t()) :: binary
  def encode(input) do
    data =
      for <<byte <- input>>,
        into: <<>>,
        do: <<byte + 15 &&& 0xFF::size(8)>>

    <<data::binary, 0x19::size(8)>>
  end

  @spec decode(binary) :: iodata
  def decode(input) do
    for <<byte <- input>>,
      into: "",
      do: decode_byte(byte)
  end

  defp decode_byte(byte) when byte > 14,
    do: <<(byte - 15) ^^^ 195::utf8>>

  defp decode_byte(byte),
    do: <<(256 - (15 - byte)) ^^^ 195::utf8>>
end
