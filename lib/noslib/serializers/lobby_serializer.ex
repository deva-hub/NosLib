defmodule NosLib.LobbySerializer do
  @moduledoc """
  Responses from the world server to select
  a character
  """
  import NosLib.Packet
  alias NosLib.CharacterSerializer

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
          name: String.t(),
          gender: atom,
          hair: CharacterSerializer.hair(),
          class: atom,
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
          id: String.t(),
          name: String.t(),
          level: pos_integer
        }

  @type load_character :: %{
          id: String.t(),
          name: String.t(),
          group_id: String.t(),
          family: family,
          authority: pos_integer,
          gender: CharacterSerializer.gender(),
          hair: CharacterSerializer.hair(),
          class: CharacterSerializer.class(),
          dignity: pos_integer,
          compliment: pos_integer,
          morph: pos_integer,
          invisible?: boolean,
          sp_upgrade?: boolean,
          arena_winner?: boolean
        }

  @spec render(:list_characters, list_characters) :: [String.t()]
  def render(:list_characters, param) do
    characters = serialize_characters(param.characters)

    [
      "clist_start #{length(characters)}",
      characters,
      "clist_end"
    ]
  end

  @spec render(:load_character, load_character) :: [String.t()]
  def render(:load_character, param) do
    [serialize_load_character(param)]
  end

  @spec serialize_load_character(load_character) :: String.t()
  defp serialize_load_character(param) do
    assemble([
      "c_info",
      param.name,
      "-",
      param.group_id,
      serialize_family(param.family),
      param.id,
      param.authority,
      CharacterSerializer.serialize_gender(param.gender),
      CharacterSerializer.serialize_hair_style(param.hair.style),
      CharacterSerializer.serialize_hair_color(param.hair.color),
      CharacterSerializer.serialize_class(param.class),
      param.dignity,
      param.compliment,
      param.morph,
      param.invisible?,
      Map.get(param.family, :level, 0),
      param.sp_upgrade?,
      param.arena_winner?
    ])
  end

  @spec serialize_family(family) :: String.t()
  def serialize_family(family) do
    assemble([
      Map.get(family, :id, -1),
      Map.get(family, :name, "-")
    ])
  end

  @spec serialize_characters([character]) :: String.t()
  defp serialize_characters(characters) do
    Enum.map(characters, &serialize_character(&1))
  end

  @spec serialize_character(character) :: String.t()
  defp serialize_character(character) do
    assemble([
      "clist",
      character.slot,
      character.name,
      0,
      CharacterSerializer.serialize_gender(character.gender),
      CharacterSerializer.serialize_hair_style(character.hair.style),
      CharacterSerializer.serialize_hair_color(character.hair.color),
      0,
      CharacterSerializer.serialize_class(character.class),
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

  @spec serialize_equipment([equipment]) :: String.t()
  defp serialize_equipment(equipment) do
    flatten([
      Map.get(equipment, :hat),
      Map.get(equipment, :armor),
      Map.get(equipment, :weapon_skin),
      Map.get(equipment, :main_weapon),
      Map.get(equipment, :secondary_weapon),
      Map.get(equipment, :mask),
      Map.get(equipment, :fairy),
      Map.get(equipment, :costume_suit),
      Map.get(equipment, :costume_hat)
    ])
  end

  @spec serialize_pets([pet]) :: String.t()
  defp serialize_pets(pets) do
    assemble(pets, &serialize_pet/1)
  end

  @spec serialize_pet(pet) :: String.t()
  defp serialize_pet(pet) do
    flatten([
      pet.skin_id,
      pet.id
    ])
  end
end
