defmodule NosLib.CharNEWDecoder do
  @moduledoc """
  Create a new character in the lobby.
  """
  alias NosLib.Character

  @type hair :: %{
          optional(:style) => bitstring,
          optional(:color) => bitstring
        }

  @type t :: %{
          optional(:slot) => non_neg_integer,
          optional(:name) => bitstring,
          optional(:gender) => Character.gender(),
          optional(:hair) => Character.hair()
        }

  @index_fields [0, 1, 2, 3, 4]

  @spec decode(iodata) :: t
  def decode(packet) when length(packet) == 5 do
    for {v, i} <- Enum.with_index(packet), i in @index_fields, reduce: %{} do
      map ->
        case i do
          0 ->
            Map.put(map, :name, v)

          1 ->
            Map.put(map, :slot, String.to_integer(v))

          2 ->
            Map.put(map, :gender, Character.decode_gender(v))

          3 ->
            v = Character.decode_hair_style(v)
            Map.update(map, :hair, %{style: v}, &Map.put(&1, :style, v))

          4 ->
            v = Character.decode_hair_color(v)
            Map.update(map, :hair, %{color: v}, &Map.put(&1, :color, v))
        end
    end
  end

  def decode(_packet),
    do: %{}
end
