defmodule NosLib.CreateCharacterCommand do
  use Bitwise, only_operators: true
  import NosLib.CharacterUtil

  @type t :: %__MODULE__{
          slot: integer,
          name: String.t(),
          gender: String.t(),
          hair: %{
            style: String.t(),
            color: String.t()
          }
        }

  defstruct slot: -1,
            name: "",
            gender: "",
            hair: %{
              style: "",
              color: ""
            }

  @spec decode!(binary) :: t
  def decode!(payload) do
    %__MODULE__{
      slot: Enum.at(payload, 1) |> String.to_integer(),
      name: Enum.at(payload, 0),
      gender: Enum.at(payload, 2) |> deserialize_gender(),
      hair: %{
        style: Enum.at(payload, 3) |> deserialize_hair_style(),
        color: Enum.at(payload, 4) |> deserialize_hair_color()
      }
    }
  rescue
    _e in ArgumentError ->
      reraise NosLib.ParserError, [packet: payload], __STACKTRACE__
  end
end
