defmodule NosLib.Character do
  @moduledoc false

  @sex BiMap.new([
         {"female", "0"},
         {"male", "1"}
       ])

  def decode_sex(s), do: BiMap.get(@sex, s)
  def encode_sex(s), do: BiMap.get_key(@sex, s)

  @hair_style BiMap.new([
                {"a", "0"},
                {"b", "1"}
              ])

  def decode_hair_style(s), do: BiMap.get(@hair_style, s)
  def encode_hair_style(s), do: BiMap.get_key(@hair_style, s)

  @hair_color BiMap.new([
                {"mauve_taupe", "0"},
                {"cerise", "1"},
                {"san_marino", "2"},
                {"affair", "3"},
                {"dixie", "4"},
                {"raven", "5"},
                {"killarney", "6"},
                {"nutmeg", "7"},
                {"saddle", "8"},
                {"red", "9}"}
              ])

  def decode_hair_color(s), do: BiMap.get(@hair_color, s)
  def encode_hair_color(s), do: BiMap.get_key(@hair_color, s)

  @class BiMap.new([
           {"adventurer", "0"},
           {"sorcerer", "1"},
           {"archer", "2"},
           {"swordsman", "3"},
           {"martial_artist", "4}"}
         ])

  def decode_class(s), do: BiMap.get(@class, s)
  def encode_class(s), do: BiMap.get_key(@class, s)
end
