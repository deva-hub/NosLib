defmodule NosLib.HandoffCommand do
  use Bitwise, only_operators: true

  @type t :: %__MODULE__{
          client_id: pos_integer,
          identifier: String.t(),
          password: String.t()
        }

  defstruct client_id: 0,
            identifier: "",
            password: ""

  @spec decode!(binary) :: t
  def decode!(payload) do
    %__MODULE__{
      client_id: Enum.at(payload, 1),
      identifier: Enum.at(payload, 2),
      password: Enum.at(payload, 3)
    }
  rescue
    _e in ArgumentError ->
      reraise NosLib.ParserError, [packet: payload], __STACKTRACE__
  end
end
