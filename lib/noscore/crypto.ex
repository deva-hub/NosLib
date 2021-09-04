defmodule Noscore.Crypto do
  @callback encrypt(binary, keyword) :: binary
  @callback decrypt(binary, keyword) :: binary
end
