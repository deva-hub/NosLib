defmodule Noscore.HudSignal do
  def name_color(:white), do: 0
  def name_color(:purple), do: 2
  def name_color(:invisible), do: 6

  def dignity_icon(:neutral), do: -100
  def dignity_icon(:suspected), do: -201
  def dignity_icon(:bluffed_name_only), do: -401
  def dignity_icon(:not_qualified_for), do: -601
  def dignity_icon(:useless), do: -801

  def reputation_icon(reputation) do
    case reputation do
      :stupid_minded -> -800
      :useless -> -600
      :not_qualified_for -> -400
      :bluffed_name_only -> -200
      :suspected -> -99
      :neutral -> 0
      :beginner -> 250
      :trainee_g -> 500
      :trainee_b -> 750
      :trainee_r -> 1_000
      :the_experienced_g -> 2_250
      :the_experienced_b -> 3_500
      :the_experienced_r -> 5_000
      :battle_soldier_g -> 9_500
      :battle_soldier_b -> 19_000
      :battle_soldier_r -> 25_000
      :expert_g -> 40_000
      :expert_b -> 60_000
      :expert_r -> 85_000
      :leader_g -> 115_000
      :leader_b -> 150_000
      :leader_r -> 190_000
      :master_g -> 235_000
      :master_b -> 185_000
      :master_r -> 350_000
      :nos_g -> 500_000
      :nos_b -> 1_500_000
      :nos_r -> 2_500_000
      :elite_g -> 3_750_000
      :elite_b -> 5_000_000
    end
  end
end
