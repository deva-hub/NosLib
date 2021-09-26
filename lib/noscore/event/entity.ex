defmodule Noscore.Event.Entity do
  import Noscore.Event.Helpers
  alias Noscore.Event.{Client, HUD, Society}

  def c_info_event(event) do
    nslist([
      nsstring("c_info"),
      nsstring(event.entity.name),
      nsstring(""),
      nsint(event.group_id),
      nsint(event.family_id),
      nsstring(event.family_name),
      nsint(event.entity.id),
      HUD.name_color(event.name_color),
      sex(event.entity.sex),
      hair_style(event.entity.hair_style),
      hair_color(event.entity.hair_color),
      class(event.entity.class),
      Society.reputation(event.entity.reputation),
      nsint(event.entity.compliment),
      nsint(event.morph),
      nsbool(event.invisible?),
      nsint(event.family_level),
      nsint(event.morph_upgrade),
      nsbool(event.arena_winner?)
    ])
  end

  def tit_event(tit_event) do
    nslist([
      nsstring("tit"),
      nsstring(tit_event.title),
      nsstring(tit_event.name)
    ])
  end

  def fd_event(event) do
    nslist([
      nsstring("fd"),
      Society.reputation(event.entity.reputation),
      HUD.dignity_icon(event.entity.reputation),
      Society.dignity(event.entity.dignity),
      HUD.reputation_icon(event.entity.dignity)
    ])
  end

  def lev_event(lev) do
    nslist([
      nsstring("lev"),
      nsint(lev.entity.level),
      nsint(lev.entity.job_level),
      nsint(lev.entity.job_xp),
      nsint(lev.entity.xp_max),
      nsint(lev.entity.job_xp_max),
      Society.reputation(lev.entity.reputation),
      nsint(lev.cp),
      nsint(lev.entity.hero_xp),
      nsint(lev.entity.hero_level),
      nsint(lev.entity.hero_xp_max)
    ])
  end

  def at_event(event) do
    nslist([
      nsstring("at"),
      nsint(event.id),
      nsint(event.map.id),
      nsint(event.position.coordinate_x),
      nsint(event.position.coordinate_y),
      nsint(2),
      nsint(0),
      nsint(event.ambiance.id),
      nsint(-1)
    ])
  end

  def type(:character), do: nsint(1)
  def type(:npc), do: nsint(2)
  def type(:monster), do: nsint(3)
  def type(:map_object), do: nsint(9)
  def type(:gateway), do: nsint(1000)

  def fairy_element(:neutral), do: nsint(1)
  def fairy_element(:fire), do: nsint(2)
  def fairy_element(:water), do: nsint(3)
  def fairy_element(:light), do: nsint(4)
  def fairy_element(:darkness), do: nsint(4)

  def fairy_movement(:neutral), do: nsint(0)
  def fairy_movement(:god), do: nsint(1)

  def direction(:north), do: nsint(1)
  def direction(:east), do: nsint(2)
  def direction(:south), do: nsint(3)
  def direction(:west), do: nsint(4)
  def direction(:north_east), do: nsint(5)
  def direction(:south_east), do: nsint(6)
  def direction(:south_west), do: nsint(7)
  def direction(:north_west), do: nsint(8)

  def sex(:male), do: nsint(0)
  def sex(:female), do: nsint(1)

  def hair_style(:a), do: nsint(0)
  def hair_style(:b), do: nsint(1)
  def hair_style(:c), do: nsint(2)
  def hair_style(:d), do: nsint(3)
  def hair_style(:shave), do: nsint(4)

  def hair_color(:mauve_taupe), do: nsint(0)
  def hair_color(:cerise), do: nsint(1)
  def hair_color(:san_marino), do: nsint(2)
  def hair_color(:affair), do: nsint(3)
  def hair_color(:dixie), do: nsint(4)
  def hair_color(:raven), do: nsint(5)
  def hair_color(:killarney), do: nsint(6)
  def hair_color(:nutmeg), do: nsint(7)
  def hair_color(:saddle), do: nsint(8)
  def hair_color(:red), do: nsint(9)

  def class(:adventurer), do: nsint(0)
  def class(:sorcerer), do: nsint(1)
  def class(:archer), do: nsint(2)
  def class(:swordsman), do: nsint(3)
  def class(:martial_artist), do: nsint(4)

  def in_event(event) do
    nslist([
      nsstring("in"),
      type(event.type),
      nsstring(event.entity.name),
      nsstring(""),
      nsint(event.id),
      nsint(event.entity.position.coordinate_x),
      nsint(event.entity.position.coordinate_y),
      direction(event.entity.position.direction),
      Client.name_color(event.name_color),
      sex(event.entity.sex),
      hair_style(event.entity.hair_style),
      hair_color(event.entity.hair_color),
      class(event.entity.class),
      equipments(event.entity.equipment),
      nsint(event.hp_percent),
      nsint(event.mp_percent),
      nsbool(event.sitting?),
      nsint(event.group_id),
      fairy_movement(event.fairy_movement),
      fairy_element(event.fairy_element),
      nsint(0),
      nsint(event.fairy_morph),
      nsint(0),
      nsint(event.morph),
      nsint(event.weapon_upgrade),
      nsint(event.armor_upgrade),
      nsint(event.family_id),
      nsstring(event.family_name),
      Society.reputation(event.entity.reputation),
      nsbool(event.invisible?),
      nsint(event.morph_upgrade),
      Society.faction(event.entity.faction),
      nsint(event.morph_bonus),
      nsint(event.entity.level),
      nsint(event.family_level),
      nsstring(event.family_icons),
      nsint(event.entity.compliment),
      nsint(event.size),
      nsint(0),
      nsint(0),
      nsint(0)
    ])
  end

  def equipments(equipment) do
    nsstruct([
      Map.get(equipment.hat, :id, -1) |> nsint(),
      Map.get(equipment.armor, :id, -1) |> nsint(),
      Map.get(equipment.weapon_skin, :id, -1) |> nsint(),
      Map.get(equipment.main_weapon, :id, -1) |> nsint(),
      Map.get(equipment.secondary_weapon, :id, -1) |> nsint(),
      Map.get(equipment.mask, :id, -1) |> nsint(),
      Map.get(equipment.fairy, :id, -1) |> nsint(),
      Map.get(equipment.costume_suit, :id, -1) |> nsint(),
      Map.get(equipment.costume_hat, :id, -1) |> nsint()
    ])
  end

  def mv_event(event) do
    nslist([
      nsstring("mv"),
      type(event.entity_type),
      nsint(event.entity.id),
      nsint(event.position.coordinate_x),
      nsint(event.position.coordinate_y),
      nsint(event.speed)
    ])
  end
end
