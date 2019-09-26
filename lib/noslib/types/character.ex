defmodule NosLib.Character do
  @moduledoc false

  @type class :: String.t()
  @type gender :: String.t()
  @type hair :: %{
          style: String.t(),
          color: String.t()
        }

  @spec decode_gender(String.t()) :: iodata
  def decode_gender("0"), do: "male"
  def decode_gender("1"), do: "female"

  @spec decode_hair_style(String.t()) :: iodata
  def decode_hair_style("0"), do: "a"
  def decode_hair_style("1"), do: "b"

  @spec decode_hair_color(String.t()) :: iodata
  def decode_hair_color("0"), do: "mauve_taupe"
  def decode_hair_color("1"), do: "cerise"
  def decode_hair_color("2"), do: "san_marino"
  def decode_hair_color("3"), do: "affair"
  def decode_hair_color("4"), do: "dixie"
  def decode_hair_color("5"), do: "raven"
  def decode_hair_color("6"), do: "killarney"
  def decode_hair_color("7"), do: "nutmeg"
  def decode_hair_color("8"), do: "saddle"
  def decode_hair_color("9"), do: "red"

  @spec encode_class(Character.class()) :: iodata
  def encode_class("adventurer"), do: "0"
  def encode_class("sorcerer"), do: "1"
  def encode_class("archer"), do: "2"
  def encode_class("swordsman"), do: "3"
  def encode_class("martial_artist"), do: "4"

  @spec encode_hair_style(String.t()) :: iodata
  def encode_hair_style("a"), do: "0"
  def encode_hair_style("b"), do: "1"

  @spec encode_hair_color(String.t()) :: iodata
  def encode_hair_color("mauve_taupe"), do: "0"
  def encode_hair_color("cerise"), do: "1"
  def encode_hair_color("san_marino"), do: "2"
  def encode_hair_color("affair"), do: "3"
  def encode_hair_color("dixie"), do: "4"
  def encode_hair_color("raven"), do: "5"
  def encode_hair_color("killarney"), do: "6"
  def encode_hair_color("nutmeg"), do: "7"
  def encode_hair_color("saddle"), do: "8"
  def encode_hair_color("red"), do: "9"

  @spec encode_gender(Character.gender()) :: iodata
  def encode_gender("male"), do: "0"
  def encode_gender("female"), do: "1"
end
