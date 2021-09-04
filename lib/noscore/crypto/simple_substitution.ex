defmodule Noscore.Crypto.SimpleSubstitution do
  @moduledoc """
  NosTale simple substitution cipher crypto
  """
  use Bitwise, only_operators: true

  @behaviour Noscore.Crypto

  def encrypt(plaintext, _ \\ []) do
    <<encrypt_data(plaintext)::binary, 0x19::size(8)>>
  end

  defp encrypt_data(data) do
    for <<b <- data>>, into: <<>> do
      <<b + 15 &&& 0xFF::size(8)>>
    end
  end

  def decrypt(ciphertext, _ \\ []) do
    for <<b <- ciphertext>>, into: "" do
      if b > 14 do
        <<Bitwise.bxor(b - 15, 195)::utf8>>
      else
        <<Bitwise.bxor(256 - (15 - b), 195)::utf8>>
      end
    end
  end
end
