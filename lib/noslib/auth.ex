defmodule NosLib.Auth do
  alias NosLib.Auth.SignIn

  def decode!(packet) when is_binary(packet) do
    decode!(String.split(packet))
  end

  def decode!(["NoS0575" | payload]) do
    SignIn.decode!(payload)
  end

  def decode!(_packet) do
    :unknown
  end
end
