defmodule Noscore.EntitySignal do
  alias Noscore.ClientSignal
  alias Noscore.HudSignal
  alias Noscore.SocietySignal

  def c_info_frame(signal) do
    [
      "c_info",
      signal.entity.name,
      "",
      signal.group_id,
      signal.family_id,
      signal.family_name,
      signal.entity.id,
      HudSignal.name_color(signal.name_color),
      sex(signal.entity.sex),
      hair_style(signal.entity.hair_style),
      hair_color(signal.entity.hair_color),
      class(signal.entity.class),
      SocietySignal.reputation(signal.entity.reputation),
      signal.entity.compliment,
      signal.morph,
      signal.invisible?,
      signal.family_level,
      signal.morph_upgrade,
      signal.arena_winner?
    ]
  end

  def tit_frame(tit_event) do
    [
      "tit",
      tit_event.title,
      tit_event.name
    ]
  end

  def fd_frame(signal) do
    [
      "fd",
      SocietySignal.reputation(signal.entity.reputation),
      HudSignal.dignity_icon(signal.entity.reputation),
      SocietySignal.dignity(signal.entity.dignity),
      HudSignal.reputation_icon(signal.entity.dignity)
    ]
  end

  def lev_frame(lev) do
    [
      "lev",
      lev.entity.level,
      lev.entity.job_level,
      lev.entity.job_xp,
      lev.entity.xp_max,
      lev.entity.job_xp_max,
      SocietySignal.reputation(lev.entity.reputation),
      lev.cp,
      lev.entity.hero_xp,
      lev.entity.hero_level,
      lev.entity.hero_xp_max
    ]
  end

  def at_frame(signal) do
    [
      "at",
      signal.id,
      signal.map.id,
      signal.position.coordinate_x,
      signal.position.coordinate_y,
      2,
      0,
      signal.ambiance.id,
      -1
    ]
  end

  def type(:character), do: 1
  def type(:npc), do: 2
  def type(:monster), do: 3
  def type(:map_object), do: 9
  def type(:gateway), do: 1000

  def fairy_element(:neutral), do: 1
  def fairy_element(:fire), do: 2
  def fairy_element(:water), do: 3
  def fairy_element(:light), do: 4
  def fairy_element(:darkness), do: 4

  def fairy_movement(:neutral), do: 0
  def fairy_movement(:god), do: 1

  def direction(:north), do: 1
  def direction(:east), do: 2
  def direction(:south), do: 3
  def direction(:west), do: 4
  def direction(:north_east), do: 5
  def direction(:south_east), do: 6
  def direction(:south_west), do: 7
  def direction(:north_west), do: 8

  def sex(:male), do: 0
  def sex(:female), do: 1

  def hair_style(:a), do: 0
  def hair_style(:b), do: 1
  def hair_style(:c), do: 2
  def hair_style(:d), do: 3
  def hair_style(:shave), do: 4

  def hair_color(:mauve_taupe), do: 0
  def hair_color(:cerise), do: 1
  def hair_color(:san_marino), do: 2
  def hair_color(:affair), do: 3
  def hair_color(:dixie), do: 4
  def hair_color(:raven), do: 5
  def hair_color(:killarney), do: 6
  def hair_color(:nutmeg), do: 7
  def hair_color(:saddle), do: 8
  def hair_color(:red), do: 9

  def class(:adventurer), do: 0
  def class(:sorcerer), do: 1
  def class(:archer), do: 2
  def class(:swordsman), do: 3
  def class(:martial_artist), do: 4

  def in_frame(signal) do
    [
      "in",
      type(signal.type),
      signal.entity.name,
      "",
      signal.id,
      signal.entity.position.coordinate_x,
      signal.entity.position.coordinate_y,
      direction(signal.entity.position.direction),
      ClientSignal.name_color(signal.name_color),
      sex(signal.entity.sex),
      hair_style(signal.entity.hair_style),
      hair_color(signal.entity.hair_color),
      class(signal.entity.class),
      equipments(signal.entity.equipment),
      signal.hp_percent,
      signal.mp_percent,
      signal.sitting?,
      signal.group_id,
      fairy_movement(signal.fairy_movement),
      fairy_element(signal.fairy_element),
      0,
      signal.fairy_morph,
      0,
      signal.morph,
      signal.weapon_upgrade,
      signal.armor_upgrade,
      signal.family_id,
      signal.family_name,
      SocietySignal.reputation(signal.entity.reputation),
      signal.invisible?,
      signal.morph_upgrade,
      SocietySignal.faction(signal.entity.faction),
      signal.morph_bonus,
      signal.entity.level,
      signal.family_level,
      signal.family_icons,
      signal.entity.compliment,
      signal.size,
      0,
      0,
      0
    ]
  end

  def equipments(equipment) do
    Enum.join(
      [
        Map.get(equipment.hat, :id, -1),
        Map.get(equipment.armor, :id, -1),
        Map.get(equipment.weapon_skin, :id, -1),
        Map.get(equipment.main_weapon, :id, -1),
        Map.get(equipment.secondary_weapon, :id, -1),
        Map.get(equipment.mask, :id, -1),
        Map.get(equipment.fairy, :id, -1),
        Map.get(equipment.costume_suit, :id, -1),
        Map.get(equipment.costume_hat, :id, -1)
      ],
      "."
    )
  end

  def mv_frame(signal) do
    [
      "mv",
      type(signal.entity_type),
      signal.entity.id,
      signal.position.coordinate_x,
      signal.position.coordinate_y,
      signal.speed
    ]
  end
end
