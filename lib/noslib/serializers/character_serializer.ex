defmodule NosLib.CharacterSerializer do
  @moduledoc """
  Response from the character actions on the
  world
  """
  import NosLib.SerializerUtil
  import NosLib.CharacterUtil

  @type position :: %{
          x: integer,
          y: integer
        }

  @type spawn_character :: %{
          id: String.t(),
          music_id: integer,
          map_name: String.t(),
          position: position
        }

  @type family :: %{
          id: String.t(),
          name: String.t(),
          level: pos_integer
        }

  @type character_info :: %{
          id: String.t(),
          name: String.t(),
          group_id: String.t(),
          family: family,
          authority: pos_integer,
          gender: CharacterUtil.gender(),
          hair: CharacterUtil.hair(),
          class: CharacterUtil.class(),
          dignity: pos_integer,
          compliment: pos_integer,
          morph: pos_integer,
          invisible?: boolean,
          sp_upgrade?: boolean,
          arena_winner?: boolean
        }

  @spec render(:spawn_character, spawn_character) :: [String.t()]
  def render(:spawn_character, param) do
    [
      serialize_params([
        "at",
        param.id,
        normalize_name(param.map_name),
        param.position_x,
        param.position_y,
        2,
        0,
        param.music_id,
        1,
        -1
      ])
    ]
  end

  @spec render(:character_info, character_info) :: [String.t()]
  def render(:character_info, param) do
    [
      serialize_params([
        "c_info",
        normalize_name(param.name),
        "-",
        param.group_id,
        param.family.id,
        normalize_name(param.family.name),
        param.id,
        param.authority,
        serialize_gender(param.gender),
        serialize_hair_style(param.hair.style),
        serialize_hair_color(param.hair.color),
        serialize_class(param.class),
        param.dignity,
        param.compliment,
        param.morph,
        serialize_boolean(param.invisible?),
        param.family.level,
        serialize_boolean(param.sp_upgrade?),
        serialize_boolean(param.arena_winner?)
      ])
    ]
  end
end
