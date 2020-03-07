defmodule Noslib.Character do
  @moduledoc false

  @gender BiMap.new([
            {"male", "0"},
            {"female", "1"}
          ])

  def decode_gender(s), do: BiMap.get(@gender, s)
  def encode_gender(s), do: BiMap.get_key(@gender, s)

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
