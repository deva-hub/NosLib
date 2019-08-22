defmodule NosLib.CharacterUtil do
  @type class ::
          :adventurer
          | :archer
          | :martial_artist
          | :sorcerer
          | :swordsman

  @type hair_style :: :a | :b

  @type hair_color ::
          :affair
          | :cerise
          | :dixie
          | :killarney
          | :mauve_taupe
          | :nutmeg
          | :raven
          | :red
          | :saddle
          | :san_marino

  @type hair :: %{
          style: hair_style,
          color: hair_color
        }

  @type gender :: :female | :male

  @spec serialize_class(class) :: non_neg_integer
  def serialize_class("adventurer"), do: 0
  def serialize_class("sorcerer"), do: 1
  def serialize_class("archer"), do: 2
  def serialize_class("swordsman"), do: 3
  def serialize_class("martial_artist"), do: 4

  @spec deserialize_class(non_neg_integer) :: class
  def deserialize_class("0"), do: "adventurer"
  def deserialize_class("1"), do: "sorcerer"
  def deserialize_class("2"), do: "archer"
  def deserialize_class("3"), do: "swordsman"
  def deserialize_class("4"), do: "martial_artist"

  @spec serialize_class(hair_style) :: non_neg_integer
  def serialize_hair_style("a"), do: 0
  def serialize_hair_style("b"), do: 1

  @spec deserialize_hair_style(non_neg_integer) :: hair_style
  def deserialize_hair_style("0"), do: "a"
  def deserialize_hair_style("1"), do: "b"

  @spec serialize_hair_color(hair_color) :: non_neg_integer
  def serialize_hair_color("cerise"), do: 1
  def serialize_hair_color("red"), do: 9
  def serialize_hair_color("nutmeg"), do: 7
  def serialize_hair_color("saddle"), do: 8
  def serialize_hair_color("raven"), do: 5
  def serialize_hair_color("dixie"), do: 4
  def serialize_hair_color("killarney"), do: 6
  def serialize_hair_color("san_marino"), do: 2
  def serialize_hair_color("affair"), do: 3
  def serialize_hair_color("mauve_taupe"), do: 0

  @spec deserialize_hair_color(non_neg_integer) :: hair_color
  def deserialize_hair_color("1"), do: "cerise"
  def deserialize_hair_color("9"), do: "red"
  def deserialize_hair_color("7"), do: "nutmeg"
  def deserialize_hair_color("8"), do: "saddle"
  def deserialize_hair_color("5"), do: "raven"
  def deserialize_hair_color("4"), do: "dixie"
  def deserialize_hair_color("6"), do: "killarney"
  def deserialize_hair_color("2"), do: "san_marino"
  def deserialize_hair_color("3"), do: "affair"
  def deserialize_hair_color("0"), do: "mauve_taupe"

  @spec serialize_gender(gender) :: non_neg_integer
  def serialize_gender("male"), do: 0
  def serialize_gender("female"), do: 1

  @spec deserialize_gender(non_neg_integer) :: gender
  def deserialize_gender("0"), do: "male"
  def deserialize_gender("1"), do: "female"
end
