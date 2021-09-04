defmodule Noscore.Crypto.Clear do
  @behaviour Noscore.Crypto

  def encrypt(plaintext, _ \\ []) do
    plaintext
  end

  def decrypt(ciphertext, _ \\ []) do
    ciphertext
  end
end
