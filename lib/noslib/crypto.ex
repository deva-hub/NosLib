defmodule Noslib.Crypto do
  @spec decrypt(binary) :: binary
  def decrypt(type, data, opts \\ [])

  def decrypt(:login, data, _) when is_binary(data) do
    Noslib.Crypto.Login.decrypt(data)
  end

  @spec encrypt(binary) :: binary
  def encrypt(:world, data, opt) when is_binary(data) do
    Noslib.Crypto.World.decrypt(world, opt)
  end
end
