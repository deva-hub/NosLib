defmodule NosLib.NoS0575Packet do
  @moduledoc """
  Packet for the first client authentication to the login server.
  """

  @type packet :: %{
          optional(identifier) => binary,
          optional(password) => binary,
          optional(client_version) => binary
        }

  @spec unmarshal(binary) :: packet
  def unmarshal(packet) when length(packet) === 5 do
    packet
    |> Enum.with_index()
    |> Enum.reduce(%{}, &unmarshal_field/2)
  end

  def unmarshal(_packet),
    do: %{}

  def unmarshal_field({value, 1}, acc),
    do: Map.put(acc, :identifier, value)

  def unmarshal_field({value, 2}, acc),
    do: Map.put(acc, :password, normalize_password(value))

  def unmarshal_field({value, 4}, acc),
    do: Map.put(acc, :client_version, normalize_version(value))

  def unmarshal_field(_element, acc),
    do: acc

  @nostale_version_regex ~r/(\d*)\.(\d*)\.(\d*)\.(\d*)/

  defp normalize_version(version) do
    Regex.replace(@nostale_version_regex, version, "\\1.\\2.\\3-\\4")
  end

  defp normalize_password(password) do
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
