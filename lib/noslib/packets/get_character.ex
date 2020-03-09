defmodule NosLib.GetCharacter do
  @moduledoc """
  GetCharacter is used to load a given character to the world.
  """
  import NosLib.Helpers
  alias NosLib.Character

  @type t :: %{
          id: non_neg_integer,
          name: String.t(),
          group_id: non_neg_integer,
          familly_id: non_neg_integer,
          familly_name: String.t(),
          familly_level: pos_integer,
          authority: non_neg_integer,
          sex: Character.sex(),
          hair_color: Character.hair_color(),
          hair_style: Character.hair_style(),
          class: Character.class(),
          dignity: non_neg_integer,
          compliment: non_neg_integer,
          morph: non_neg_integer,
          invisible?: boolean,
          sp_upgrade?: boolean,
          arena_winner?: boolean
        }

  defstruct id: 0,
            name: "",
            group_id: 0,
            familly_id: 0,
            familly_name: "",
            familly_level: 1,
            authority: 0,
            sex: "female",
            hair_color: "a",
            hair_style: "mauve_taupe",
            class: "adventurer",
            dignity: 0,
            compliment: 0,
            morph: 0,
            invisible?: false,
            sp_upgrade?: false,
            arena_winner?: false

  def deserialize([
        id,
        name,
        group_id,
        familly_id,
        familly_name,
        authority,
        sex,
        hair_color,
        hair_style,
        class,
        dignity,
        compliment,
        morph,
        invisible,
        familly_level,
        sp_upgrade,
        arena_winner
      ]) do
    %__MODULE__{
      id: id |> String.to_integer(),
      name: name,
      group_id: group_id |> String.to_integer(),
      familly_id: familly_id |> String.to_integer(),
      familly_name: familly_name,
      authority: authority |> String.to_integer(),
      sex: sex |> Character.decode_sex(),
      hair_color: hair_color |> Character.decode_hair_color(),
      hair_style: hair_style |> Character.decode_hair_style(),
      class: class |> String.to_integer(),
      dignity: dignity |> String.to_integer(),
      compliment: compliment |> String.to_integer(),
      morph: morph |> String.to_integer(),
      invisible?: invisible |> decode_boolean(),
      familly_level: familly_level |> String.to_integer(),
      sp_upgrade?: sp_upgrade |> decode_boolean(),
      arena_winner?: arena_winner |> decode_boolean()
    }
  end
end

defimpl NosLib.Encoder, for: NosLib.GetCharacter do
  import NosLib.Helpers
  alias NosLib.Character

  def serialize(packet) do
    [
      "c_info",
      packet.name,
      "-",
      packet.group_id |> to_string(),
      packet.familly_id |> to_string(),
      packet.familly_name,
      packet.id |> to_string(),
      packet.authority |> to_string(),
      packet.sex |> Character.encode_sex(),
      packet.hair_style |> Character.encode_hair_style(),
      packet.hair_color |> Character.encode_hair_color(),
      packet.class |> Character.encode_class(),
      packet.dignity |> to_string(),
      packet.compliment |> to_string(),
      packet.morph |> to_string(),
      packet.invisible? |> encode_boolean(),
      packet.familly_level |> to_string(),
      packet.sp_upgrade? |> encode_boolean(),
      packet.arena_winner? |> encode_boolean()
    ]
  end
end
