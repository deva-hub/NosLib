defmodule NosLib.Commands.Auth do
  alias NosLib.Commands.Auth.SignIn

  def decode(["NoS0575" | payload]) do
    %{
      identifier: Enum.at(payload, 1),
      password: Enum.at(payload, 2),
      client_version: Enum.at(payload, 4)
    }
  end

  def decode(_packet) do
    :unknown
  end
end
