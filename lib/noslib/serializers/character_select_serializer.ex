defmodule NosLib.CharacterSelectSerializer do
  @moduledoc """
  Responses from the world server to select
  a character
  """
  import NosLib.SerializerUtil
  import NosLib.CharacterUtil

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
          hair: CharacterUtil.hair(),
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

  @spec render(:list_characters, list_characters) :: [String.t()]
  def render(:list_characters, param) do
    characters = serialize_characters(param.characters)

    ["clist_start #{length(characters)}"]
    |> Enum.concat(characters)
    |> Enum.concat(["clist_end"])
  end

  @spec serialize_characters([character]) :: String.t()
  defp serialize_characters(characters) do
    Enum.map(characters, &serialize_character(&1))
  end

  @spec serialize_character(character) :: String.t()
  defp serialize_character(character) do
    serialize_params([
      "clist",
      character.slot,
      normalize_name(character.name),
      0,
      serialize_gender(character.gender),
      serialize_hair_style(character.hair.style),
      serialize_hair_color(character.hair.color),
      0,
      serialize_class(character.class),
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
    serialize_structure([
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

  @spec serialize_pets([pet]) :: String.t()
  defp serialize_pets(pets) do
    pets = Enum.map(pets, &serialize_pet/1)

    ["-1" | pets]
    |> Enum.reverse()
    |> serialize_structure()
  end

  @spec serialize_pet(pet) :: String.t()
  defp serialize_pet(pet) do
    serialize_structure([
      pet.skin_id,
      pet.id
    ])
  end
end
