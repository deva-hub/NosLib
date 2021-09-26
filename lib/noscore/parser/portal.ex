defmodule Noscore.Parser.Gateway do
  import NimbleParsec
  import Noscore.Parser.Battle
  import Noscore.Parser.Bazar
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def key(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> eos()
  end

  def auth(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> separator()
    |> label(alphanum_string(min: 1), "identifier")
    |> separator()
    |> integer(min: 1)
    |> separator()
    |> label(alphanum_string(min: 1), "password")
    |> eos()
  end

  def event(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> separator()
    |> choice([
      header("mtlist") |> separator() |> multi_target_list(),
      header("req_exc") |> separator() |> request(),
      header("c_buy") |> separator() |> character_buy(),
      header("c_reg") |> separator() |> character_reg(),
      header("c_scalc") |> separator() |> character_scale_currency(),
      header("c_skill") |> separator() |> character_skill(),
      header("c_slist") |> separator() |> characters_list(),
      header("f_withdraw") |> separator() |> family_withdraw(),
      header("gop") |> separator() |> global_options(),
      unidentified()
    ])
    |> eos()
  end

  defp unidentified(combinator \\ empty()) do
    choice(combinator, [
      header("f_stash_end") |> separator() |> f_stash_end(),
      header("c_close") |> separator() |> c_close(),
      header("lbs") |> separator() |> lbs()
    ])
  end
end
