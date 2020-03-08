defmodule NosLib.Crypto.Login do
  @moduledoc """
  This module provides a set of functions used for decoding and encoding Gateway
  packets.
  """
  use Bitwise, only_operators: true

  @spec encrypt(binary) :: binary
  def encrypt(data) do
    <<encrypt_payload(data)::binary, 0x19::8>>
  end

  @spec decrypt(binary) :: binary
  def decrypt(data) do
    for <<byte <- data>>, into: "" do
      if byte > 14 do
        <<(byte - 15) ^^^ 195::utf8>>
      else
        <<(256 - (15 - byte)) ^^^ 195::utf8>>
      end
    end
  end

  defp encrypt_payload(payload) do
    for <<byte <- payload |> to_string()>>, into: <<>> do
      <<byte + 15 &&& 0xFF::8>>
    end
  end
end
