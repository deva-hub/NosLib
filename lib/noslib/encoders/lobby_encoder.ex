defmodule NosLib.LobbyEncoder do
  @moduledoc """
  Responses from the world server to select a character.
  """
  alias NosLib.Character

  @type equipment :: %{
          hat_id: pos_integer | nil,
          armor_id: pos_integer | nil,
          weapon_skin_id: pos_integer | nil,
          main_weapon_id: pos_integer | nil,
          secondary_weapon_id: pos_integer | nil,
          mask_id: pos_integer | nil,
          fairy_id: pos_integer | nil,
          costume_suit_id: pos_integer | nil,
          costume_hat_id: pos_integer | nil
        }

  @type pet :: %{
          id: pos_integer,
          skin_id: pos_integer
        }

  @type character :: %{
          slot: pos_integer,
          name: bitstring,
          gender: Character.gender(),
          hair: Character.hair(),
          class: Character.class(),
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
          id: pos_integer,
          name: bitstring,
          level: pos_integer
        }

  @type load_character :: %{
          id: pos_integer,
          name: bitstring,
          group_id: pos_integer,
          family: family,
          authority: non_neg_integer,
          gender: Character.gender(),
          hair: Character.hair(),
          class: Character.class(),
          dignity: non_neg_integer,
          compliment: non_neg_integer,
          morph: non_neg_integer,
          invisible?: boolean,
          sp_upgrade?: boolean,
          arena_winner?: boolean
        }

  @pets_end "-1"

  @spec encode(:list_characters, list_characters) :: [binary]
  def encode(:list_characters, param) do
    characters = :binary.list_to_bin(encode_characters(param.characters))
    header = :binary.list_to_bin(encode_character_header(characters))

    [
      header,
      characters,
      "clist_end"
    ]
  end

  @spec encode(:load_character, load_character) :: [binary]
  def encode(:load_character, param),
    do: [encode_load_character(param)]

  @spec encode_to_iodata(:list_characters, list_characters) :: [iodata]
  def encode_to_iodata(:list_characters, param) do
    characters = encode_characters(param.characters)
    header = encode_character_header(characters)

    [
      header,
      characters,
      "clist_end"
    ]
  end

  @spec encode_to_iodata(:load_character, load_character) :: [iodata]
  def encode_to_iodata(:load_character, param),
    do: [encode_load_character(param)]

  defp encode_character_header(characters) do
    [
      "clist_start",
      " ",
      IO.iodata_length(characters)
    ]
  end

  defp encode_load_character(param) do
    [
      "c_info",
      " ",
      param.name,
      " ",
      "-",
      " ",
      Integer.to_string(param.group_id),
      " ",
      encode_family(param.family),
      " ",
      Integer.to_string(param.id),
      " ",
      Integer.to_string(param.authority),
      " ",
      Character.encode_gender(param.gender),
      " ",
      encode_hair(param.hair),
      " ",
      Character.encode_class(param.class),
      " ",
      Integer.to_string(param.dignity),
      " ",
      Integer.to_string(param.compliment),
      " ",
      Integer.to_string(param.morph),
      " ",
      if(param.invisible?, do: "1", else: 0),
      " ",
      Integer.to_string(param.family.level),
      " ",
      if(param.sp_upgrade?, do: "1", else: 0),
      " ",
      if(param.arena_winner?, do: "1", else: 0)
    ]
  end

  def encode_family(family) do
    [
      Integer.to_string(family.id),
      " ",
      family.name
    ]
  end

  defp encode_hair(hair) do
    [
      Character.encode_hair_style(hair.style),
      " ",
      Character.encode_hair_color(hair.color)
    ]
  end

  defp encode_characters(characters) do
    characters
    |> Enum.map(&encode_character(&1))
    |> Enum.intersperse(" ")
  end

  defp encode_character(character) do
    [
      "clist",
      " ",
      Integer.to_string(character.slot),
      " ",
      character.name,
      " ",
      "0",
      " ",
      Character.encode_gender(character.gender),
      " ",
      encode_hair(character.hair),
      " ",
      "0",
      " ",
      Character.encode_class(character.class),
      " ",
      Integer.to_string(character.level),
      " ",
      Integer.to_string(character.hero_level),
      " ",
      encode_equipment(character.equipment),
      " ",
      Integer.to_string(character.job_level),
      " ",
      "1",
      " ",
      "1",
      " ",
      encode_pets(character.pets),
      " ",
      "0"
    ]
  end

  defp encode_equipment(equipment) do
    [
      Map.get(equipment, :hat, "-1"),
      ".",
      Map.get(equipment, :armor, "-1"),
      ".",
      Map.get(equipment, :weapon_skin, "-1"),
      ".",
      Map.get(equipment, :main_weapon, "-1"),
      ".",
      Map.get(equipment, :secondary_weapon, "-1"),
      ".",
      Map.get(equipment, :mask, "-1"),
      ".",
      Map.get(equipment, :fairy, "-1"),
      ".",
      Map.get(equipment, :costume_suit, "-1"),
      ".",
      Map.get(equipment, :costume_hat, "-1")
    ]
  end

  defp encode_pets(pets) do
    pets
    |> Enum.reduce([@pets_end], &[encode_pet(&1) | &2])
    |> Enum.intersperse(" ")
  end

  defp encode_pet(pet) do
    [
      Integer.to_string(pet.skin_id),
      ".",
      Integer.to_string(pet.id)
    ]
  end
end
