defmodule Noscore.SocietySignal do
  def reputation(signal) do
    case signal do
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

  def dignity(:neutral), do: 1
  def dignity(:suspected), do: 2
  def dignity(:bluffed_name_only), do: 3
  def dignity(:not_qualified_for), do: 4
  def dignity(:useless), do: 5
  def dignity(:stupid_minded), do: 6

  def faction(:neutral), do: 0
  def faction(:angel), do: 1
  def faction(:demon), do: 2

  def miniland(:open), do: 0
  def miniland(:private), do: 1
  def miniland(:lock), do: 2
end
