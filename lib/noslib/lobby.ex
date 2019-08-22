defmodule NosLib.Lobby do
  alias NosLib.Lobby.{
    CreateCharacter,
    DeleteCharacter,
    SelectCharacter
  }

  def decode!(packet) when is_binary(packet) do
    decode!(String.split(packet))
  end

  def decode!(["Char_NEW" | payload]) do
    CreateCharacter.decode!(payload)
  end

  def decode!(["Char_DEL" | payload]) do
    DeleteCharacter.decode!(payload)
  end

  def decode!(["select" | payload]) do
    SelectCharacter.decode!(payload)
  end

  def decode!(_packet) do
    :unknown
  end
end
