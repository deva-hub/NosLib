defmodule NosLib.LoginCrypto do
  @moduledoc """
  This module provides a set of cryptographic functions
  used for the Login protocol.
  """

  use Bitwise, only_operators: true

  @doc """
  Encrypt a login response to binary.
  """
  @spec encrypt(String.t()) :: binary
  def encrypt(binary) do
    data = for <<c <- binary>>, into: <<>>, do: <<c + 15 &&& 0xFF::size(8)>>
    <<data::binary, 0x19::size(8)>>
  end

  @doc """
  Decrypt a login packet.
  """
  @spec decrypt(binary) :: binary
  def decrypt(binary) do
    for(<<c <- binary>>, into: "", do: decrypt_char(c))
  end

  @spec decrypt_char(byte) :: binary
  defp decrypt_char(byte) do
    case byte do
      c when c > 14 -> <<(c - 15) ^^^ 195::utf8>>
      c -> <<(256 - (15 - c)) ^^^ 195::utf8>>
    end
  end
end
