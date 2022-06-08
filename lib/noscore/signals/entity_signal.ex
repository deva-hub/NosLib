defmodule Noscore.EntitySignal do
  import Noscore.SignalHelpers
  alias Noscore.ClientSignal
  alias Noscore.HudSignal
  alias Noscore.SocietySignal

  def c_info_frame(signal) do
    to_frame([
      to_frame("c_info"),
      to_frame(signal.entity.name),
      to_frame(""),
      to_frame(signal.group_id),
      to_frame(signal.family_id),
      to_frame(signal.family_name),
      to_frame(signal.entity.id),
      HudSignal.name_color(signal.name_color),
      sex(signal.entity.sex),
      hair_style(signal.entity.hair_style),
      hair_color(signal.entity.hair_color),
      class(signal.entity.class),
      SocietySignal.reputation(signal.entity.reputation),
      to_frame(signal.entity.compliment),
      to_frame(signal.morph),
      to_frame(signal.invisible?),
      to_frame(signal.family_level),
      to_frame(signal.morph_upgrade),
      to_frame(signal.arena_winner?)
    ])
  end

  def tit_frame(tit_event) do
    to_frame([
      to_frame("tit"),
      to_frame(tit_event.title),
      to_frame(tit_event.name)
    ])
  end

  def fd_frame(signal) do
    to_frame([
      to_frame("fd"),
      SocietySignal.reputation(signal.entity.reputation),
      HudSignal.dignity_icon(signal.entity.reputation),
      SocietySignal.dignity(signal.entity.dignity),
      HudSignal.reputation_icon(signal.entity.dignity)
    ])
  end

  def lev_frame(lev) do
    to_frame([
      to_frame("lev"),
      to_frame(lev.entity.level),
      to_frame(lev.entity.job_level),
      to_frame(lev.entity.job_xp),
      to_frame(lev.entity.xp_max),
      to_frame(lev.entity.job_xp_max),
      SocietySignal.reputation(lev.entity.reputation),
      to_frame(lev.cp),
      to_frame(lev.entity.hero_xp),
      to_frame(lev.entity.hero_level),
      to_frame(lev.entity.hero_xp_max)
    ])
  end

  def at_frame(signal) do
    to_frame([
      to_frame("at"),
      to_frame(signal.id),
      to_frame(signal.map.id),
      to_frame(signal.position.coordinate_x),
      to_frame(signal.position.coordinate_y),
      to_frame(2),
      to_frame(0),
      to_frame(signal.ambiance.id),
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

  def in_frame(signal) do
    to_frame([
      to_frame("in"),
      type(signal.type),
      to_frame(signal.entity.name),
      to_frame(""),
      to_frame(signal.id),
      to_frame(signal.entity.position.coordinate_x),
      to_frame(signal.entity.position.coordinate_y),
      direction(signal.entity.position.direction),
      ClientSignal.name_color(signal.name_color),
      sex(signal.entity.sex),
      hair_style(signal.entity.hair_style),
      hair_color(signal.entity.hair_color),
      class(signal.entity.class),
      equipments(signal.entity.equipment),
      to_frame(signal.hp_percent),
      to_frame(signal.mp_percent),
      to_frame(signal.sitting?),
      to_frame(signal.group_id),
      fairy_movement(signal.fairy_movement),
      fairy_element(signal.fairy_element),
      to_frame(0),
      to_frame(signal.fairy_morph),
      to_frame(0),
      to_frame(signal.morph),
      to_frame(signal.weapon_upgrade),
      to_frame(signal.armor_upgrade),
      to_frame(signal.family_id),
      to_frame(signal.family_name),
      SocietySignal.reputation(signal.entity.reputation),
      to_frame(signal.invisible?),
      to_frame(signal.morph_upgrade),
      SocietySignal.faction(signal.entity.faction),
      to_frame(signal.morph_bonus),
      to_frame(signal.entity.level),
      to_frame(signal.family_level),
      to_frame(signal.family_icons),
      to_frame(signal.entity.compliment),
      to_frame(signal.size),
      to_frame(0),
      to_frame(0),
      to_frame(0)
    ])
  end

  def equipments(equipment) do
    Enum.intersperse(
      [
        Map.get(equipment.hat, :id, -1) |> to_frame(),
        Map.get(equipment.armor, :id, -1) |> to_frame(),
        Map.get(equipment.weapon_skin, :id, -1) |> to_frame(),
        Map.get(equipment.main_weapon, :id, -1) |> to_frame(),
        Map.get(equipment.secondary_weapon, :id, -1) |> to_frame(),
        Map.get(equipment.mask, :id, -1) |> to_frame(),
        Map.get(equipment.fairy, :id, -1) |> to_frame(),
        Map.get(equipment.costume_suit, :id, -1) |> to_frame(),
        Map.get(equipment.costume_hat, :id, -1) |> to_frame()
      ],
      "."
    )
  end

  def mv_frame(signal) do
    to_frame([
      to_frame("mv"),
      type(signal.entity_type),
      to_frame(signal.entity.id),
      to_frame(signal.position.coordinate_x),
      to_frame(signal.position.coordinate_y),
      to_frame(signal.speed)
    ])
  end
end
