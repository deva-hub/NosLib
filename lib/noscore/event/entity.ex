defmodule Noscore.Event.Entity do
  import Noscore.Event.Helpers
  alias Noscore.Event.{Client, HUD, Society}

  def c_info_event(event) do
    to_frame([
      to_frame("c_info"),
      to_frame(event.entity.name),
      to_frame(""),
      to_frame(event.group_id),
      to_frame(event.family_id),
      to_frame(event.family_name),
      to_frame(event.entity.id),
      HUD.name_color(event.name_color),
      sex(event.entity.sex),
      hair_style(event.entity.hair_style),
      hair_color(event.entity.hair_color),
      class(event.entity.class),
      Society.reputation(event.entity.reputation),
      to_frame(event.entity.compliment),
      to_frame(event.morph),
      to_frame(event.invisible?),
      to_frame(event.family_level),
      to_frame(event.morph_upgrade),
      to_frame(event.arena_winner?)
    ])
  end

  def tit_event(tit_event) do
    to_frame([
      to_frame("tit"),
      to_frame(tit_event.title),
      to_frame(tit_event.name)
    ])
  end

  def fd_event(event) do
    to_frame([
      to_frame("fd"),
      Society.reputation(event.entity.reputation),
      HUD.dignity_icon(event.entity.reputation),
      Society.dignity(event.entity.dignity),
      HUD.reputation_icon(event.entity.dignity)
    ])
  end

  def lev_event(lev) do
    to_frame([
      to_frame("lev"),
      to_frame(lev.entity.level),
      to_frame(lev.entity.job_level),
      to_frame(lev.entity.job_xp),
      to_frame(lev.entity.xp_max),
      to_frame(lev.entity.job_xp_max),
      Society.reputation(lev.entity.reputation),
      to_frame(lev.cp),
      to_frame(lev.entity.hero_xp),
      to_frame(lev.entity.hero_level),
      to_frame(lev.entity.hero_xp_max)
    ])
  end

  def at_event(event) do
    to_frame([
      to_frame("at"),
      to_frame(event.id),
      to_frame(event.map.id),
      to_frame(event.position.coordinate_x),
      to_frame(event.position.coordinate_y),
      to_frame(2),
      to_frame(0),
      to_frame(event.ambiance.id),
      to_frame(-1)
    ])
  end

  def type(:character), do: to_frame(1)
  def type(:npc), do: to_frame(2)
  def type(:monster), do: to_frame(3)
  def type(:map_object), do: to_frame(9)
  def type(:gateway), do: to_frame(1000)

  def fairy_element(:neutral), do: to_frame(1)
  def fairy_element(:fire), do: to_frame(2)
  def fairy_element(:water), do: to_frame(3)
  def fairy_element(:light), do: to_frame(4)
  def fairy_element(:darkness), do: to_frame(4)

  def fairy_movement(:neutral), do: to_frame(0)
  def fairy_movement(:god), do: to_frame(1)

  def direction(:north), do: to_frame(1)
  def direction(:east), do: to_frame(2)
  def direction(:south), do: to_frame(3)
  def direction(:west), do: to_frame(4)
  def direction(:north_east), do: to_frame(5)
  def direction(:south_east), do: to_frame(6)
  def direction(:south_west), do: to_frame(7)
  def direction(:north_west), do: to_frame(8)

  def sex(:male), do: to_frame(0)
  def sex(:female), do: to_frame(1)

  def hair_style(:a), do: to_frame(0)
  def hair_style(:b), do: to_frame(1)
  def hair_style(:c), do: to_frame(2)
  def hair_style(:d), do: to_frame(3)
  def hair_style(:shave), do: to_frame(4)

  def hair_color(:mauve_taupe), do: to_frame(0)
  def hair_color(:cerise), do: to_frame(1)
  def hair_color(:san_marino), do: to_frame(2)
  def hair_color(:affair), do: to_frame(3)
  def hair_color(:dixie), do: to_frame(4)
  def hair_color(:raven), do: to_frame(5)
  def hair_color(:killarney), do: to_frame(6)
  def hair_color(:nutmeg), do: to_frame(7)
  def hair_color(:saddle), do: to_frame(8)
  def hair_color(:red), do: to_frame(9)

  def class(:adventurer), do: to_frame(0)
  def class(:sorcerer), do: to_frame(1)
  def class(:archer), do: to_frame(2)
  def class(:swordsman), do: to_frame(3)
  def class(:martial_artist), do: to_frame(4)

  def in_event(event) do
    to_frame([
      to_frame("in"),
      type(event.type),
      to_frame(event.entity.name),
      to_frame(""),
      to_frame(event.id),
      to_frame(event.entity.position.coordinate_x),
      to_frame(event.entity.position.coordinate_y),
      direction(event.entity.position.direction),
      Client.name_color(event.name_color),
      sex(event.entity.sex),
      hair_style(event.entity.hair_style),
      hair_color(event.entity.hair_color),
      class(event.entity.class),
      equipments(event.entity.equipment),
      to_frame(event.hp_percent),
      to_frame(event.mp_percent),
      to_frame(event.sitting?),
      to_frame(event.group_id),
      fairy_movement(event.fairy_movement),
      fairy_element(event.fairy_element),
      to_frame(0),
      to_frame(event.fairy_morph),
      to_frame(0),
      to_frame(event.morph),
      to_frame(event.weapon_upgrade),
      to_frame(event.armor_upgrade),
      to_frame(event.family_id),
      to_frame(event.family_name),
      Society.reputation(event.entity.reputation),
      to_frame(event.invisible?),
      to_frame(event.morph_upgrade),
      Society.faction(event.entity.faction),
      to_frame(event.morph_bonus),
      to_frame(event.entity.level),
      to_frame(event.family_level),
      to_frame(event.family_icons),
      to_frame(event.entity.compliment),
      to_frame(event.size),
      to_frame(0),
      to_frame(0),
      to_frame(0)
    ])
  end

  def equipments(equipment) do
    Enum.intersperse([
      Map.get(equipment.hat, :id, -1) |> to_frame(),
      Map.get(equipment.armor, :id, -1) |> to_frame(),
      Map.get(equipment.weapon_skin, :id, -1) |> to_frame(),
      Map.get(equipment.main_weapon, :id, -1) |> to_frame(),
      Map.get(equipment.secondary_weapon, :id, -1) |> to_frame(),
      Map.get(equipment.mask, :id, -1) |> to_frame(),
      Map.get(equipment.fairy, :id, -1) |> to_frame(),
      Map.get(equipment.costume_suit, :id, -1) |> to_frame(),
      Map.get(equipment.costume_hat, :id, -1) |> to_frame()
    ], ".")
  end

  def mv_event(event) do
    to_frame([
      to_frame("mv"),
      type(event.entity_type),
      to_frame(event.entity.id),
      to_frame(event.position.coordinate_x),
      to_frame(event.position.coordinate_y),
      to_frame(event.speed)
    ])
  end
end
