defmodule NosLib.Auth.SignIn do
  use Bitwise, only_operators: true

  @type t :: %__MODULE__{
          identifier: String.t(),
          password: String.t(),
          client_version: String.t()
        }

  defstruct identifier: "",
            password: "",
            client_version: ""

  @spec decode!(binary) :: t
  def decode!(payload) do
    %__MODULE__{
      identifier: Enum.at(payload, 1),
      password: Enum.at(payload, 2) |> deserialize_password(),
      client_version: Enum.at(payload, 4)
    }
  rescue
    _e in ArgumentError ->
      reraise NosLib.ParserError, [packet: payload], __STACKTRACE__
  end

  defp deserialize_password(binary) do
    case binary |> String.length() |> rem(2) do
      0 -> String.slice(binary, 3..-1)
      1 -> String.slice(binary, 4..-1)
    end
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x | _] -> x end)
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer(&1, 16))
    |> to_string
  end
end
