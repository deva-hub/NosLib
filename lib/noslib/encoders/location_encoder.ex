defmodule NosLib.LocationEncoder do
  @moduledoc """
  Character actions and interaction command with the world.
  """

  @type position :: %{
          x: integer,
          y: integer
        }

  @type spawn_character :: %{
          id: pos_integer,
          music_id: pos_integer,
          map_name: bitstring,
          position: position
        }

  @spec encode(:spawn_character, spawn_character) :: [binary]
  def encode(:spawn_character, param),
    do: [IO.iodata_to_binary(encode_spawn_character(param))]

  @spec encode_to_iodata(:spawn_character, spawn_character) :: [iodata]
  def encode_to_iodata(:spawn_character, param),
    do: [encode_spawn_character(param)]

  defp encode_spawn_character(param) do
    [
      "at",
      " ",
      Integer.to_string(param.id),
      " ",
      param.map_name,
      " ",
      encode_position(param.position),
      " ",
      "2",
      " ",
      "0",
      " ",
      Integer.to_string(param.music_id),
      " ",
      "-1"
    ]
  end

  defp encode_position(position) do
    [
      Integer.to_string(position.x),
      " ",
      Integer.to_string(position.y)
    ]
  end
end
