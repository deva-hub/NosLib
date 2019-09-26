defmodule NosLib.NoS0575Decoder do
  @moduledoc """
  Decoder for the first client authentication to the login server.
  """

  @type packet :: %{
          optional(:identifier) => bitstring,
          optional(:password) => bitstring,
          optional(:client_version) => bitstring
        }

  @index_fields [1, 2, 4]

  @spec decode(iodata) :: packet
  def decode(packet) when length(packet) == 5 do
    for {v, i} <- Enum.with_index(packet), i in @index_fields, into: %{} do
      case i do
        1 -> {:identifier, v}
        2 -> {:password, decode_password(v)}
        4 -> {:client_version, decode_version(v)}
      end
    end
  end

  def decode(_packet),
    do: %{}

  @nostale_version_regex ~r/(\d*)\.(\d*)\.(\d*)\.(\d*)/

  defp decode_version(version),
    do: Regex.replace(@nostale_version_regex, version, "\\1.\\2.\\3-\\4")

  defp decode_password(password) do
    slice_position =
      password
      |> String.length()
      |> rem(2)

    chunks =
      case slice_position do
        0 -> String.slice(password, 3..-1)
        1 -> String.slice(password, 4..-1)
      end

    chunks
    |> String.codepoints()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [x | _] -> x end)
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer(&1, 16))
    |> List.to_string()
  end
end
