defmodule Noscore.HudSignal do
  import Noscore.SignalHelpers

  def name_color(:white), do: to_frame(0)
  # def name_color(:???,) do: to_frame(1)
  def name_color(:purple), do: to_frame(2)
  # def name_color(:???,) do: to_frame(3)
  # def name_color(:???,) do: to_frame(4)
  # def name_color(:???,) do: to_frame(5)
  def name_color(:invisible), do: to_frame(6)

  def dignity_icon(:neutral), do: to_frame(-100)
  def dignity_icon(:suspected), do: to_frame(-201)
  def dignity_icon(:bluffed_name_only), do: to_frame(-401)
  def dignity_icon(:not_qualified_for), do: to_frame(-601)
  def dignity_icon(:useless), do: to_frame(-801)

  def reputation_icon(reputation) do
    case reputation do
      :stupid_minded -> to_frame(-800)
      :useless -> to_frame(-600)
      :not_qualified_for -> to_frame(-400)
      :bluffed_name_only -> to_frame(-200)
      :suspected -> to_frame(-99)
      :neutral -> to_frame(0)
      :beginner -> to_frame(250)
      :trainee_g -> to_frame(500)
      :trainee_b -> to_frame(750)
      :trainee_r -> to_frame(1_000)
      :the_experienced_g -> to_frame(2_250)
      :the_experienced_b -> to_frame(3_500)
      :the_experienced_r -> to_frame(5_000)
      :battle_soldier_g -> to_frame(9_500)
      :battle_soldier_b -> to_frame(19_000)
      :battle_soldier_r -> to_frame(25_000)
      :expert_g -> to_frame(40_000)
      :expert_b -> to_frame(60_000)
      :expert_r -> to_frame(85_000)
      :leader_g -> to_frame(115_000)
      :leader_b -> to_frame(150_000)
      :leader_r -> to_frame(190_000)
      :master_g -> to_frame(235_000)
      :master_b -> to_frame(185_000)
      :master_r -> to_frame(350_000)
      :nos_g -> to_frame(500_000)
      :nos_b -> to_frame(1_500_000)
      :nos_r -> to_frame(2_500_000)
      :elite_g -> to_frame(3_750_000)
      :elite_b -> to_frame(5_000_000)
    end
  end
end
