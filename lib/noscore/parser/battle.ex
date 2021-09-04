defmodule Noscore.Parser.Battle do
  import NimbleParsec
  import Noscore.Parser.Helpers

  def mtlist(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "targets amount")
    |> separator()
    |> label(
      repeat(multi_target_list_sub_packet() |> lookahead(choice([space(), eos()]))),
      "targets"
    )
  end

  def multi_target_list_sub_packet(combinator \\ empty()) do
    combinator
    |> label(alphanum_string(min: 1), "skill id")
    |> separator()
    |> label(alphanum_string(min: 1), "target id")
  end

  def req_exc(combinator \\ empty()) do
    combinator
    |> label(alphanum_string(min: 1), "character id")
    |> separator()
    |> label(request_type(), "request type")
  end

  def request_type(combinator \\ empty()) do
    choice(combinator, [
      string("1") |> replace(:requested),
      string("2") |> replace(:list),
      string("3") |> replace(:confirmed),
      string("4") |> replace(:cancelled),
      string("5") |> replace(:declined)
    ])
  end
end
