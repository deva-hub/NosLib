defmodule NosLib.Crypto do
  @moduledoc false

  @type options :: keyword()

  @callback decrypt(binary, options) :: binary
  @callback encrypt(binary, options) :: binary
end
