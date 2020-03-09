defmodule NosLib.CharacterPosition do
  @moduledoc """
  CharacterPosition is the event of character movement.
  """

  @type t :: %__MODULE__{
          id: non_neg_integer,
          map_name: String.t(),
          music_id: non_neg_integer,
          x: integer,
          y: integer
        }

  defstruct id: 0,
            map_name: "",
            music_id: 0,
            x: 0,
            y: 0

  def deserialize(packet) do
    character(%__MODULE__{}, packet)
  end

  defp character(packet, [id | rest]) do
    zone(%{packet | id: id}, rest)
  end

  defp zone(packet, [map_name | rest]) do
    location(%{packet | map_name: map_name}, rest)
  end

  defp location(packet, [x, y, _, _ | rest]) do
    ambiance(%{packet | x: x |> String.to_integer(), y: y |> String.to_integer()}, rest)
  end

  defp ambiance(packet, [music_id, _]) do
    %{packet | music_id: music_id}
  end
end

defimpl NosLib.Encoder, for: NosLib.CharacterPosition do
  def serialize(packet) do
    [
      "at",
      packet.id |> to_string(),
      packet.map,
      packet.x |> to_string(),
      packet.y |> to_string(),
      "2",
      "0",
      packet.music |> to_string(),
      "-1"
    ]
  end
end
