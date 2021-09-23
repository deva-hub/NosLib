defmodule Noscore.Event.Entity do
  import Noscore.Event.Helpers
  alias Noscore.Event.{Client, HUD, Society}

  def c_info_packet(packet) do
    nslist([
      nsstring("c_info"),
      nsstring(packet.entity.name),
      nsstring(""),
      nsint(packet.group_id),
      nsint(packet.family_id),
      nsstring(packet.family_name),
      nsint(packet.entity.id),
      HUD.name_color(packet.name_color),
      sex(packet.entity.sex),
      hair_style(packet.entity.hair_style),
      hair_color(packet.entity.hair_color),
      class(packet.entity.class),
      Society.reputation(packet.entity.reputation),
      nsint(packet.entity.compliment),
      nsint(packet.morph),
      nsbool(packet.invisible?),
      nsint(packet.family_level),
      nsint(packet.morph_upgrade),
      nsbool(packet.arena_winner?)
    ])
  end

  def tit_packet(tit_packet) do
    nslist([
      nsstring("tit"),
      nsstring(tit_packet.title),
      nsstring(tit_packet.name)
    ])
  end

  def fd_packet(packet) do
    nslist([
      nsstring("fd"),
      Society.reputation(packet.entity.reputation),
      HUD.dignity_icon(packet.entity.reputation),
      Society.dignity(packet.entity.dignity),
      HUD.reputation_icon(packet.entity.dignity)
    ])
  end

  def lev_packet(lev) do
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

  def at_packet(packet) do
    nslist([
      nsstring("at"),
      nsint(packet.id),
      nsint(packet.map.id),
      nsint(packet.position.coordinate_x),
      nsint(packet.position.coordinate_y),
      nsint(2),
      nsint(0),
      nsint(packet.ambiance.id),
      nsint(-1)
    ])
  end

  def type(:character), do: nsint(1)
  def type(:npc), do: nsint(2)
  def type(:monster), do: nsint(3)
  def type(:map_object), do: nsint(9)
  def type(:portal), do: nsint(1000)

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

  def in_packet(packet) do
    nslist([
      nsstring("in"),
      type(packet.type),
      nsstring(packet.entity.name),
      nsstring(""),
      nsint(packet.id),
      nsint(packet.entity.position.coordinate_x),
      nsint(packet.entity.position.coordinate_y),
      direction(packet.entity.position.direction),
      Client.name_color(packet.name_color),
      sex(packet.entity.sex),
      hair_style(packet.entity.hair_style),
      hair_color(packet.entity.hair_color),
      class(packet.entity.class),
      equipments(packet.entity.equipment),
      nsint(packet.hp_percent),
      nsint(packet.mp_percent),
      nsbool(packet.sitting?),
      nsint(packet.group_id),
      fairy_movement(packet.fairy_movement),
      fairy_element(packet.fairy_element),
      nsint(0),
      nsint(packet.fairy_morph),
      nsint(0),
      nsint(packet.morph),
      nsint(packet.weapon_upgrade),
      nsint(packet.armor_upgrade),
      nsint(packet.family_id),
      nsstring(packet.family_name),
      Society.reputation(packet.entity.reputation),
      nsbool(packet.invisible?),
      nsint(packet.morph_upgrade),
      Society.faction(packet.entity.faction),
      nsint(packet.morph_bonus),
      nsint(packet.entity.level),
      nsint(packet.family_level),
      nsstring(packet.family_icons),
      nsint(packet.entity.compliment),
      nsint(packet.size),
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

  def mv_packet(packet) do
    nslist([
      nsstring("mv"),
      type(packet.entity_type),
      nsint(packet.entity.id),
      nsint(packet.position.coordinate_x),
      nsint(packet.position.coordinate_y),
      nsint(packet.speed)
    ])
  end
end
