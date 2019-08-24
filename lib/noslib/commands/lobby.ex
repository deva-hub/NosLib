defmodule NosLib.Commands.Lobby do
  alias NosLib.Commands.Lobby.{
    CreateCharacter,
    DeleteCharacter,
    SelectCharacter
  }

  def decode("Char_NEW", payload) do
    %{
      slot: Enum.at(payload, 1),
      name: Enum.at(payload, 0),
      gender: Enum.at(payload, 2),
      hair: %{
        style: Enum.at(payload, 3),
        color: Enum.at(payload, 4)
      }
    }
  end

  def decode("Char_DEL", payload) do
    %{
      slot: Enum.at(payload, 0),
      name: Enum.at(payload, 1)
    }
  end

  def decode("select", payload) do
    %{
      slot: Enum.at(payload, 0)
    }
  end

  def decode(_packet) do
    {:error, :unknown}
  end
end
