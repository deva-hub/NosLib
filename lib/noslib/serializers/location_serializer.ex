defmodule NosLib.LocationSerializer do
  @moduledoc """
  Character actions and interaction command with the world.
  """
  import NosLib.Packet

  @type position :: %{
          x: integer,
          y: integer
        }

  @type spawn_character :: %{
          id: binary,
          music_id: integer,
          map_name: binary,
          position: position
        }

  def marshal(template, param)

  @spec marshal(:spawn_character, spawn_character) :: [binary]
  def marshal(:spawn_character, param),
    do: [serialize_spawn_character(param)]

  defp serialize_spawn_character(param) do
    assemble([
      "at",
      param.id,
      param.map_name,
      param.position.x,
      param.position.y,
      "2",
      "0",
      param.music_id,
      -1
    ])
  end
end
