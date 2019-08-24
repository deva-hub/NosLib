defmodule NosLib.LocationSerializer do
  @moduledoc """
  Response from the character actions on the
  world
  """
  import NosLib.Packet
  import NosLib.CharacterSerializer

  @type position :: %{
          x: integer,
          y: integer
        }

  @type spawn_character :: %{
          id: String.t(),
          music_id: integer,
          map_name: String.t(),
          position: position
        }

  @spec render(:spawn_character, spawn_character) :: [String.t()]
  def render(:spawn_character, param) do
    [serialize_spawn_character(param)]
  end

  @spec serialize_spawn_character(spawn_character) :: String.t()
  defp serialize_spawn_character(param) do
    assemble([
      "at",
      param.id,
      param.map_name,
      param.position_x,
      param.position_y,
      "2",
      "0",
      param.music_id,
      -1
    ])
  end
end
