defmodule Noscore.Parser do
  import NimbleParsec
  import Noscore.BattleCommand
  import Noscore.BazarCommand
  import Noscore.ClientCommand
  import Noscore.GatewayCommand
  import Noscore.ProtocolHelpers

  defparsec(:login, string("nos0575") |> ignore(space()) |> nos0575())

  defparsec(
    :world,
    choice([
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
  )
end
