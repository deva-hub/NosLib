defmodule NosLib.Lobby.SelectCharacter do
  use Bitwise, only_operators: true

  @type t :: %__MODULE__{
          slot: integer
        }

  defstruct slot: -1

  @spec decode!(binary) :: t
  def decode!(payload) do
    %__MODULE__{
      slot: Enum.at(payload, 0) |> String.to_integer()
    }
  rescue
    _e in ArgumentError ->
      reraise NosLib.ParserError, [packet: payload], __STACKTRACE__
  end
end
