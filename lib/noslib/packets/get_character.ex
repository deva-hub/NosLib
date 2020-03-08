defmodule NosLib.GetCharacter do
  @moduledoc """
  Responses from the world server to select a character.
  """

  alias NosLib.Character

  @type t :: %{
          id: non_neg_integer,
          name: String.t(),
          group_id: non_neg_integer,
          familly_id: non_neg_integer,
          familly_name: String.t(),
          familly_level: non_neg_integer,
          authority: non_neg_integer,
          gender: Character.gender(),
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

  defstruct [
    :id,
    :name,
    :group_id,
    :familly_id,
    :familly_name,
    :familly_level,
    :authority,
    :gender,
    :hair_style,
    :hair_color,
    :class,
    :dignity,
    :compliment,
    :morph,
    :invisible?,
    :sp_upgrade?,
    :arena_winner?
  ]

  def deserialize(packet) do
    user(%__MODULE__{}, packet)
  end

  defp user(packet, [id, name, group_id | rest]) do
    familly_id(%{packet | id: id, name: name, group_id: group_id}, rest)
  end

  defp familly_id(packet, [familly_id, familly_name | rest]) do
    authority(%{packet | familly_id: familly_id, familly_name: familly_name}, rest)
  end

  defp authority(packet, [authority | rest]) do
    character(%{packet | authority: authority}, rest)
  end

  defp character(packet, [gender | rest]) do
    hair(%{packet | gender: gender}, rest)
  end

  defp hair(packet, [color, style | rest]) do
    character_2(%{packet | hair_color: hair_color, hair_style: hair_style}, rest)
  end

  defp character_2(packet, [class | rest]) do
    mode(%{packet | class: class}, rest)
  end

  defp mode(packet, [dignity, compliment | rest]) do
    apparence(%{packet | dignity: dignity, compliment: compliment}, rest)
  end

  defp apparence(packet, [morph, invisible | rest]) do
    familly_2(%{packet | morph: morph, invisible: invisible}, rest)
  end

  defp familly_2(packet, [familly_level | rest]) do
    aura(%{packet | familly_level: familly_level}, rest)
  end

  defp aura(packet, [sp_upgrade, arena_winner]) do
    %{packet | sp_upgrade: sp_upgrade, arena_winner: arena_winner}
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
      packet.gender |> Character.encode_gender(),
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
