defmodule NosLib.SlotStream.Chunk do
  @moduledoc """
  Chunk is the a character information.
  """
  import NosLib.Helpers
  alias NosLib.{Character, Equipment, Pet}

  @type t :: %{
          index: non_neg_integer,
          name: String.t(),
          sex: Character.sex(),
          hair_color: Character.hair_color(),
          hair_style: Character.hair_style(),
          class: Character.class(),
          level: integer,
          hero_level: integer,
          job_level: integer,
          equipment: Equipment.t(),
          pets: [Pet.t()]
        }

  defstruct index: 0,
            name: "",
            sex: "female",
            hair_style: "mauve_taupe",
            hair_color: "a",
            class: "adventurer",
            level: 0,
            hero_level: 0,
            job_level: 0,
            equipment: %Equipment{},
            pets: []

  def deserialize([
        index,
        _,
        name,
        sex,
        hair_style,
        hair_color,
        _,
        class,
        level,
        hero_level,
        equipment,
        job_level,
        pets,
        _,
        _
      ]) do
    %__MODULE__{
      index: index,
      name: name,
      sex: sex |> Character.decode_sex(),
      hair_style: hair_style |> Character.decode_hair_style(),
      hair_color: hair_color |> Character.decode_hair_color(),
      class: class |> Character.decode_class(),
      level: level |> String.to_integer(),
      hero_level: hero_level |> String.to_integer(),
      equipment: equipment |> decode_struct() |> Equipment.decode(),
      job_level: job_level |> String.to_integer(),
      pets: pets |> decode_enum(&(&1 |> decode_struct() |> Pet.decode()))
    }
  end
end

defimpl NosLib.Encoder, for: NosLib.SlotStream.Chunk do
  import NosLib.Helpers
  alias NosLib.{Character, Equipment, Pet}

  def serialize(packet) do
    [
      "clist",
      packet.index |> to_string(),
      packet.name,
      "0",
      packet.character.sex |> Character.encode_sex(),
      packet.character.hair_style |> Character.encode_hair_style(),
      packet.character.hair_color |> Character.encode_hair_color(),
      "0",
      packet.character.class |> Character.encode_class(),
      packet.character.level |> to_string(),
      packet.character.hero_level |> to_string(),
      packet.character.equipment |> Equipment.encode(),
      packet.character.job_level |> to_string(),
      "1",
      "1",
      packet.character.pets |> encode_enum(&(&1 |> Pet.encode() |> encode_struct())),
      "0"
    ]
  end
end
