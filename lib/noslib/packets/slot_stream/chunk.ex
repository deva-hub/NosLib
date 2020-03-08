defmodule NosLib.SlotStream.Chunk do
  import NosLib.Helpers
  alias NosLib.{Character, Equipment, Pet}

  @type t :: %{
          index: pos_integer,
          name: String.t(),
          gender: Character.gender(),
          hair_color: Character.hair_color(),
          hair_style: Character.hair_style(),
          class: Character.class(),
          level: integer,
          hero_level: integer,
          job_level: integer,
          equipment: Equipment.t(),
          pets: [Pet.t()]
        }

  defstruct [
    :index,
    :name,
    :gender,
    :hair_color,
    :hair_style,
    :class,
    :level,
    :hero_level,
    :job_level,
    :equipment,
    :pets
  ]

  def deserialize(packet) do
    character(%__MODULE__{}, packet)
  end

  def character(packet, [index, _, name, gender | rest]) do
    hair(
      %{
        packet
        | index: index,
          name: name,
          gender: gender |> Character.decode_gender()
      },
      rest
    )
  end

  def hair(packet, [hair_style, hair_color, _ | rest]) do
    character_2(
      %{
        packet
        | hair_style: hair_style |> Character.decode_hair_style(),
          hair_color: hair_color |> Character.decode_hair_color()
      },
      rest
    )
  end

  def character_2(packet, [class | rest]) do
    level(%{packet | class: class |> Character.decode_class()}, rest)
  end

  def level(packet, [level, hero_level | rest]) do
    equipment(
      %{
        packet
        | level: level |> String.to_integer(),
          hero_level: hero_level |> String.to_integer()
      },
      rest
    )
  end

  def equipment(packet, [equipment | rest]) do
    level_2(
      %{
        packet
        | equipment: equipment |> decode_struct() |> Equipment.decode()
      },
      rest
    )
  end

  def level_2(packet, [job_level | rest]) do
    pets(%{packet | job_level: job_level |> String.to_integer()}, rest)
  end

  def pets(packet, [pets, _, _]) do
    %{
      packet
      | pets: pets |> decode_enum(&(&1 |> decode_struct() |> Pet.decode()))
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
      packet.character.gender |> Character.encode_gender(),
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
