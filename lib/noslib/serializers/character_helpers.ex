defmodule NosLib.CharacterHelpers do
  @moduledoc """
  Lobby related character helpers.
  """

  @type class :: binary
  @type gender :: binary
  @type hair_style :: binary
  @type hair_color :: binary
  @type hair :: %{
          style: hair_style,
          color: hair_color
        }

  @spec serialize_class(class) :: non_neg_integer
  def serialize_class("adventurer"), do: 0
  def serialize_class("sorcerer"), do: 1
  def serialize_class("archer"), do: 2
  def serialize_class("swordsman"), do: 3
  def serialize_class("martial_artist"), do: 4

  @spec serialize_hair_style(hair_style) :: non_neg_integer
  def serialize_hair_style("a"), do: 0
  def serialize_hair_style("b"), do: 1

  @spec serialize_hair_color(hair_color) :: non_neg_integer
  def serialize_hair_color("mauve_taupe"), do: 0
  def serialize_hair_color("cerise"), do: 1
  def serialize_hair_color("san_marino"), do: 2
  def serialize_hair_color("affair"), do: 3
  def serialize_hair_color("dixie"), do: 4
  def serialize_hair_color("raven"), do: 5
  def serialize_hair_color("killarney"), do: 6
  def serialize_hair_color("nutmeg"), do: 7
  def serialize_hair_color("saddle"), do: 8
  def serialize_hair_color("red"), do: 9

  @spec serialize_gender(gender) :: non_neg_integer
  def serialize_gender("male"), do: 0
  def serialize_gender("female"), do: 1
end
