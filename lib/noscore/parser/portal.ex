defmodule Noscore.Parser.Portal do
  import NimbleParsec
  import Noscore.Parser.Battle
  import Noscore.Parser.Bazar
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def key(combinator \\ empty()) do
    alphanum_string(combinator, min: 1)
  end

  def auth(combinator \\ empty()) do
    repeat(combinator, integer(min: 1) |> ignore(space()) |> alphanum_string(min: 1))
  end

  def command(combinator \\ empty()) do
    combinator
    |> integer(min: 1)
    |> ignore(space())
    |> choice([
      string("mtlist") |> ignore(space()) |> mtlist(),
      string("multi_target_list_sub_packet") |> ignore(space()) |> multi_target_list_sub_packet(),
      string("req_exc") |> ignore(space()) |> req_exc(),
      string("c_buy") |> ignore(space()) |> c_buy(),
      string("c_reg") |> ignore(space()) |> c_reg(),
      string("c_scalc") |> ignore(space()) |> c_scalc(),
      string("c_skill") |> ignore(space()) |> c_skill(),
      string("c_slist") |> ignore(space()) |> c_slist(),
      string("f_withdraw") |> ignore(space()) |> f_withdraw(),
      string("c_close") |> ignore(space()) |> c_close(),
      string("gop") |> ignore(space()) |> gop(),
      string("character_option") |> ignore(space()) |> character_option(),
      string("f_stash_end") |> ignore(space()) |> f_stash_end(),
      string("lbs") |> ignore(space()) |> lbs()
    ])
  end
end
