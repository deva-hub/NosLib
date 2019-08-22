defmodule NosLib.Lobby.DeleteCharacter do
  use Bitwise, only_operators: true

  @type t :: %__MODULE__{
          slot: integer,
          name: String.t()
        }

  defstruct slot: -1,
            name: ""

  @spec decode!(binary) :: t
  def decode!(payload) do
    %__MODULE__{
      slot: Enum.at(payload, 0),
      name: Enum.at(payload, 1)
    }
  rescue
    _e in ArgumentError ->
      reraise NosLib.ParserError, [packet: payload], __STACKTRACE__
  end
end
