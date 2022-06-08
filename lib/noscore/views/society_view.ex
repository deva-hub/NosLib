defmodule Noscore.SocietyView do
  use Noscore.Signal

  def render("reputation.nostale", %{reputation: reputation}) do
    case reputation do
      :stupid_minded -> -6
      :useless -> -5
      :not_qualified_for -> -4
      :bluffed_name_only -> -3
      :suspected -> -2
      :neutral -> -1
      :beginner -> 1
      # :??? -> 2
      # :??? -> 3
      :trainee_g -> 4
      :trainee_b -> 5
      :trainee_r -> 6
      :the_experienced_g -> 7
      :the_experienced_b -> 8
      :the_experienced_r -> 9
      :battle_soldier_g -> 10
      :battle_soldier_b -> 11
      :battle_soldier_r -> 12
      :expert_g -> 13
      :expert_b -> 14
      :expert_r -> 15
      :leader_g -> 16
      :leader_b -> 17
      :leader_r -> 18
      :master_g -> 19
      :master_b -> 20
      :master_r -> 21
      :nos_g -> 22
      :nos_b -> 23
      :nos_r -> 24
      :elite_g -> 25
      :elite_b -> 26
      :elite_r -> 27
      :legend_g -> 28
      :legend_b -> 29
      :ancien_hero -> 30
      :mysterious_hero -> 31
      :legendary_hero -> 32
    end
  end

  def render("dignity.nostale", %{dignity: dignity}) do
    case dignity do
      :neutral -> 1
      :suspected -> 2
      :bluffed_name_only -> 3
      :not_qualified_for -> 4
      :useless -> 5
      :stupid_minded -> 6
    end
  end

  def render("faction.nostale", %{faction: faction}) do
    case faction do
      :neutral -> 0
      :angel -> 1
      :demon -> 2
    end
  end

  def render("miniland.nostale", %{miniland: miniland}) do
    case miniland do
      :open -> 0
      :private -> 1
      :lock -> 2
    end
  end
end
