defmodule NosLib.LobbySerializer do
  @moduledoc """
  Responses from the world server to select a character.
  """
  import NosLib.Packet
  alias NosLib.CharacterHelpers

  @type equipment :: %{
          hat_id: integer | nil,
          armor_id: integer | nil,
          weapon_skin_id: integer | nil,
          main_weapon_id: integer | nil,
          secondary_weapon_id: integer | nil,
          mask_id: integer | nil,
          fairy_id: integer | nil,
          costume_suit_id: integer | nil,
          costume_hat_id: integer | nil
        }

  @type pet :: %{
          id: integer,
          skin_id: integer
        }

  @type character :: %{
          slot: integer,
          name: binary,
          gender: binary,
          hair: CharacterHelpers.hair(),
          class: binary,
          level: integer,
          hero_level: integer,
          job_level: integer,
          equipment: equipment,
          pets: [pet]
        }

  @type list_characters :: %{
          characters: [character]
        }

  @type family :: %{
          id: binary,
          name: binary,
          level: pos_integer
        }

  @type load_character :: %{
          id: binary,
          name: binary,
          group_id: binary,
          family: family,
          authority: pos_integer,
          gender: CharacterHelpers.gender(),
          hair: CharacterHelpers.hair(),
          class: CharacterHelpers.class(),
          dignity: pos_integer,
          compliment: pos_integer,
          morph: pos_integer,
          invisible?: boolean,
          sp_upgrade?: boolean,
          arena_winner?: boolean
        }

  @pets_ending "-1"

  @spec render(:list_characters, list_characters) :: [binary]
  def render(:list_characters, param) do
    characters = serialize_characters(param.characters)

    [
      "clist_start #{length(characters)}",
      characters,
      "clist_end"
    ]
  end

  @spec render(:load_character, load_character) :: [binary]
  def render(:load_character, param),
    do: [serialize_load_character(param)]

  defp serialize_load_character(param) do
    assemble([
      "c_info",
      param.name,
      "-",
      param.group_id,
      serialize_family(param.family),
      param.id,
      param.authority,
      CharacterHelpers.serialize_gender(param.gender),
      CharacterHelpers.serialize_hair_style(param.hair.style),
      CharacterHelpers.serialize_hair_color(param.hair.color),
      CharacterHelpers.serialize_class(param.class),
      param.dignity,
      param.compliment,
      param.morph,
      param.invisible?,
      param.family.level,
      param.sp_upgrade?,
      param.arena_winner?
    ])
  end

  def serialize_family(family) do
    assemble([
      family.id,
      family.name
    ])
  end

  defp serialize_characters(characters),
    do: Enum.map(characters, &serialize_character(&1))

  defp serialize_character(character) do
    assemble([
      "clist",
      character.slot,
      character.name,
      0,
      CharacterHelpers.serialize_gender(character.gender),
      CharacterHelpers.serialize_hair_style(character.hair.style),
      CharacterHelpers.serialize_hair_color(character.hair.color),
      0,
      CharacterHelpers.serialize_class(character.class),
      character.level,
      character.hero_level,
      serialize_equipment(character.equipment),
      character.job_level,
      1,
      1,
      serialize_pets(character.pets),
      0
    ])
  end

  defp serialize_equipment(equipment) do
    flatten([
      Map.get(equipment, :hat, "-1"),
      Map.get(equipment, :armor, "-1"),
      Map.get(equipment, :weapon_skin, "-1"),
      Map.get(equipment, :main_weapon, "-1"),
      Map.get(equipment, :secondary_weapon, "-1"),
      Map.get(equipment, :mask, "-1"),
      Map.get(equipment, :fairy, "-1"),
      Map.get(equipment, :costume_suit, "-1"),
      Map.get(equipment, :costume_hat, "-1")
    ])
  end

  defp serialize_pets(pets),
    do: assemble(pets, @pets_ending, &serialize_pet/1)

  defp serialize_pet(pet) do
    flatten([
      pet.skin_id,
      pet.id
    ])
  end
end
