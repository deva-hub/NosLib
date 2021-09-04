defmodule Noscore.Parser.Portal do
  import NimbleParsec
  import Noscore.Parser.Battle
  import Noscore.Parser.Bazar
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def key(combinator \\ empty()) do
    combinator
    |> alphanum_string(min: 1)
    |> eos()
  end

  def auth(combinator \\ empty()) do
    combinator
    |> repeat(
      integer(min: 1)
      |> separator()
      |> alphanum_string(min: 1)
      |> lookahead(choice([space(), eos()]))
    )
    |> eos()
  end

  def command(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> separator()
    |> choice([
      header("mtlist") |> separator() |> mtlist(),
      header("multi_target_list_sub_packet") |> separator() |> multi_target_list_sub_packet(),
      header("req_exc") |> separator() |> req_exc(),
      header("c_buy") |> separator() |> c_buy(),
      header("c_reg") |> separator() |> c_reg(),
      header("c_scalc") |> separator() |> c_scalc(),
      header("c_skill") |> separator() |> c_skill(),
      header("c_slist") |> separator() |> c_slist(),
      header("f_withdraw") |> separator() |> f_withdraw(),
      header("c_close") |> separator() |> c_close(),
      header("gop") |> separator() |> gop(),
      header("character_option") |> separator() |> character_option(),
      header("f_stash_end") |> separator() |> f_stash_end(),
      header("lbs") |> separator() |> lbs()
    ])
    |> eos()
  end
end
