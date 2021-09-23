defmodule Noscore.Event.HUD do
  import Noscore.Event.Helpers

  def name_color(:white), do: nsint(0)
  # def name_color(:???,) do: nsint(1)
  def name_color(:purple), do: nsint(2)
  # def name_color(:???,) do: nsint(3)
  # def name_color(:???,) do: nsint(4)
  # def name_color(:???,) do: nsint(5)
  def name_color(:invisible), do: nsint(6)

  def dignity_icon(:neutral), do: nsint(-100)
  def dignity_icon(:suspected), do: nsint(-201)
  def dignity_icon(:bluffed_name_only), do: nsint(-401)
  def dignity_icon(:not_qualified_for), do: nsint(-601)
  def dignity_icon(:useless), do: nsint(-801)

  def reputation_icon(reputation) do
    case reputation do
      :stupid_minded -> nsint(-800)
      :useless -> nsint(-600)
      :not_qualified_for -> nsint(-400)
      :bluffed_name_only -> nsint(-200)
      :suspected -> nsint(-99)
      :neutral -> nsint(0)
      :beginner -> nsint(250)
      :trainee_g -> nsint(500)
      :trainee_b -> nsint(750)
      :trainee_r -> nsint(1_000)
      :the_experienced_g -> nsint(2_250)
      :the_experienced_b -> nsint(3_500)
      :the_experienced_r -> nsint(5_000)
      :battle_soldier_g -> nsint(9_500)
      :battle_soldier_b -> nsint(19_000)
      :battle_soldier_r -> nsint(25_000)
      :expert_g -> nsint(40_000)
      :expert_b -> nsint(60_000)
      :expert_r -> nsint(85_000)
      :leader_g -> nsint(115_000)
      :leader_b -> nsint(150_000)
      :leader_r -> nsint(190_000)
      :master_g -> nsint(235_000)
      :master_b -> nsint(185_000)
      :master_r -> nsint(350_000)
      :nos_g -> nsint(500_000)
      :nos_b -> nsint(1_500_000)
      :nos_r -> nsint(2_500_000)
      :elite_g -> nsint(3_750_000)
      :elite_b -> nsint(5_000_000)
    end
  end
end
