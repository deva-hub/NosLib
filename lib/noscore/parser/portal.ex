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
      |> ignore(space())
      |> alphanum_string(min: 1)
      |> lookahead(choice([space(), eos()]))
    )
    |> eos()
  end

  def command(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> ignore(space())
    |> choice([
      label(string("mtlist"), "header")
      |> ignore(space())
      |> mtlist(),
      label(string("multi_target_list_sub_packet"), "header")
      |> ignore(space())
      |> multi_target_list_sub_packet(),
      label(string("req_exc"), "header")
      |> ignore(space())
      |> req_exc(),
      label(string("c_buy"), "header")
      |> ignore(space())
      |> c_buy(),
      label(string("c_reg"), "header")
      |> ignore(space())
      |> c_reg(),
      label(string("c_scalc"), "header")
      |> ignore(space())
      |> c_scalc(),
      label(string("c_skill"), "header")
      |> ignore(space())
      |> c_skill(),
      label(string("c_slist"), "header")
      |> ignore(space())
      |> c_slist(),
      label(string("f_withdraw"), "header")
      |> ignore(space())
      |> f_withdraw(),
      label(string("c_close"), "header")
      |> ignore(space())
      |> c_close(),
      label(string("gop"), "header")
      |> ignore(space())
      |> gop(),
      label(string("character_option"), "header")
      |> ignore(space())
      |> character_option(),
      label(string("f_stash_end"), "header")
      |> ignore(space())
      |> f_stash_end(),
      label(string("lbs"), "header")
      |> ignore(space())
      |> lbs()
    ])
    |> eos()
  end
end
