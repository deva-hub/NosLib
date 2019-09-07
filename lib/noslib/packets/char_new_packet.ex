defmodule NosLib.CharNEWPacket do
  @moduledoc """
  Create a new character in the lobby.
  """

  @type packet :: %{
          optional(slot) => non_neg_integer,
          optional(name) => binary,
          optional(gender) => binary,
          optional(hair) => %{
            optional(style) => binary,
            optional(color) => binary
          }
        }

  @spec unmarshal(binary) :: packet
  def unmarshal(packet) when length(packet) === 5 do
    packet
    |> Enum.with_index()
    |> Enum.reduce(%{}, &unmarshal_field/2)
  end

  def unmarshal(_packet),
    do: %{}

  def unmarshal_field({value, 0}, acc),
    do: Map.put(acc, :name, value)

  def unmarshal_field({value, 1}, acc),
    do: Map.put(acc, :slot, String.to_integer(value))

  def unmarshal_field({value, 2}, acc),
    do: Map.put(acc, :gender, normalize_gender(value))

  def unmarshal_field({value, 3}, acc) do
    value = normalize_hair_style(value)
    Map.update(acc, :hair, %{style: value}, &Map.put(&1, :sytle, value))
  end

  def unmarshal_field({value, 4}, acc) do
    value = normalize_hair_color(value)
    Map.update(acc, :hair, %{color: value}, &Map.put(&1, :color, value))
  end

  def unmarshal_field(_element, acc),
    do: acc

  defp normalize_gender("0"), do: "male"
  defp normalize_gender("1"), do: "female"

  def normalize_hair_style("0"), do: "a"
  def normalize_hair_style("1"), do: "b"

  defp normalize_hair_color("0"), do: "mauve_taupe"
  defp normalize_hair_color("1"), do: "cerise"
  defp normalize_hair_color("2"), do: "san_marino"
  defp normalize_hair_color("3"), do: "affair"
  defp normalize_hair_color("4"), do: "dixie"
  defp normalize_hair_color("5"), do: "raven"
  defp normalize_hair_color("6"), do: "killarney"
  defp normalize_hair_color("7"), do: "nutmeg"
  defp normalize_hair_color("8"), do: "saddle"
  defp normalize_hair_color("9"), do: "red"
end
