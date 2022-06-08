defmodule Noscore.EntityView do
  use Noscore.Signal
  alias Noscore.ClientView
  alias Noscore.HudView
  alias Noscore.SocietyView

  def render("character.nostale", %{character: character}) do
    [
      "c_info",
      character.entity.name,
      "",
      character.group_id,
      character.family_id,
      character.family_name,
      character.entity.id,
      render_one(character.name_color, HudView, "name_color.nostale"),
      render_one(character.entity.sex, EntityView, "sex.nostale"),
      render_one(character.entity.hair_style, EntityView, "hair_style.nostale"),
      render_one(character.entity.hair_color, EntityView, "hair_color.nostale"),
      render_one(character.entity.class, EntityView, "class.nostale"),
      render_one(character.entity.reputation, SocietyView, "reputation.nostale"),
      character.entity.compliment,
      character.morph,
      character.invisible?,
      character.family_level,
      character.morph_upgrade,
      character.arena_winner?
    ]
  end

  def render("title.nostale", %{title: title}) do
    [
      "tit",
      title.content,
      title.name
    ]
  end

  def render("fd.nostale", %{fd: fd}) do
    [
      "fd",
      render_one(fd.entity.reputation, SocietyView, "reputation.nostale"),
      render_one(fd.entity.reputation, HudView, "dignity_icon.nostale"),
      render_one(fd.entity.dignity, SocietyView, "dignity.nostale"),
      render_one(fd.entity.dignity, HudView, "reputation_icon.nostale")
    ]
  end

  def render("levels.nostale", %{levels: levels}) do
    [
      "lev",
      levels.entity.level,
      levels.entity.job_level,
      levels.entity.job_xp,
      levels.entity.xp_max,
      levels.entity.job_xp_max,
      render_one(levels.entity.reputation, SocietyView, "reputation.nostale"),
      levels.cp,
      levels.entity.hero_xp,
      levels.entity.hero_level,
      levels.entity.hero_xp_max
    ]
  end

  def render("position.nostale", %{position: position}) do
    [
      "at",
      position.id,
      position.map.id,
      position.coords.x,
      position.coords.y,
      2,
      0,
      position.ambiance.id,
      -1
    ]
  end

  def render("type.nostale", %{type: type}) do
    case type do
      :character -> 1
      :npc -> 2
      :monster -> 3
      :map_object -> 9
      :gateway -> 1000
    end
  end

  def render("fairy_element.nostale", %{fairy_element: fairy_element}) do
    case fairy_element do
      :neutral -> 1
      :fire -> 2
      :water -> 3
      :light -> 4
      :darkness -> 4
    end
  end

  def render("fairy_movement.nostale", %{fairy_movement: fairy_movement}) do
    case fairy_movement do
      :neutral -> 0
      :god -> 1
    end
  end

  def render("heading.nostale", %{heading: heading}) do
    case heading do
      :north -> 1
      :east -> 2
      :south -> 3
      :west -> 4
      :north_east -> 5
      :south_east -> 6
      :south_west -> 7
      :north_west -> 8
    end
  end

  def render("sex.nostale", %{sex: sex}) do
    case sex do
      :male -> 0
      :female -> 1
    end
  end

  def render("hair_style.nostale", %{hair_style: hair_style}) do
    case hair_style do
      :a -> 0
      :b -> 1
      :c -> 2
      :d -> 3
      :shave -> 4
    end
  end

  def render("hair_color.nostale", %{hair_color: hair_color}) do
    case hair_color do
      :mauve_taupe -> 0
      :cerise -> 1
      :san_marino -> 2
      :affair -> 3
      :dixie -> 4
      :raven -> 5
      :killarney -> 6
      :nutmeg -> 7
      :saddle -> 8
      :red -> 9
    end
  end

  def render("class.nostale", %{class: class}) do
    case class do
      :adventurer -> 0
      :sorcerer -> 1
      :archer -> 2
      :swordsman -> 3
      :martial_artist -> 4
    end
  end

  def render("entity.nostale", entity) do
    [
      "in",
      render_one(entity.type, EntityView, "type.nostale"),
      entity.entity.name,
      "",
      entity.id,
      entity.entity.coords.x,
      entity.entity.coords.y,
      render_one(entity.entity.coords.heading, EntityView, "heading.nostale"),
      render_one(entity.name_color, ClientView, "name_color.nostale"),
      render_one(entity.entity.sex, EntityView, "sex.nostale"),
      render_one(entity.entity.hair_style, EntityView, "hair_style.nostale"),
      render_one(entity.entity.hair_color, EntityView, "hair_color.nostale"),
      render_one(entity.entity.class, EntityView, "class.nostale"),
      render_one(entity.entity.equipment, EntityView, "equipments.nostale"),
      entity.hp_percent,
      entity.mp_percent,
      entity.sitting?,
      entity.group_id,
      render_one(entity.fairy_movement, EntityView, "fairy_movement.nostale"),
      render_one(entity.fairy_element, EntityView, "fairy_element.nostale"),
      0,
      entity.fairy_morph,
      0,
      entity.morph,
      entity.weapon_upgrade,
      entity.armor_upgrade,
      entity.family_id,
      entity.family_name,
      render_one(entity.entity.reputation, SocietyView, "reputation.nostale"),
      entity.invisible?,
      entity.morph_upgrade,
      render_one(entity.entity.faction, SocietyView, "faction.nostale"),
      entity.morph_bonus,
      entity.entity.level,
      entity.family_level,
      entity.family_icons,
      entity.entity.compliment,
      entity.size,
      0,
      0,
      0
    ]
  end

  def render("equipments.nostale", %{equipments: equipments}) do
    Enum.join(
      [
        Map.get(equipments.hat, :id, -1),
        Map.get(equipments.armor, :id, -1),
        Map.get(equipments.weapon_skin, :id, -1),
        Map.get(equipments.main_weapon, :id, -1),
        Map.get(equipments.secondary_weapon, :id, -1),
        Map.get(equipments.mask, :id, -1),
        Map.get(equipments.fairy, :id, -1),
        Map.get(equipments.costume_suit, :id, -1),
        Map.get(equipments.costume_hat, :id, -1)
      ],
      "."
    )
  end

  def render("move.nostale", %{move: move}) do
    [
      "mv",
      render_one(move.type, EntityView, "type.nostale"),
      move.entity.id,
      move.coords.x,
      move.coords.y,
      move.speed
    ]
  end
end
