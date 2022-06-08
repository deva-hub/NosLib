defmodule Noscore.Parser.Battle do
  import NimbleParsec
  import Noscore.Parser.Helpers

  def multi_target_list(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "targets amount")
    |> separator()
    |> label(
      repeat(multi_target_element() |> lookahead(choice([space(), eos()]))),
      "targets"
    )
  end

  defp multi_target_element(combinator \\ empty()) do
    combinator
    |> label(alphanum_string(min: 1), "skill id")
    |> separator()
    |> label(alphanum_string(min: 1), "target id")
  end

  def exchange_request(combinator \\ empty()) do
    combinator
    |> label(alphanum_string(min: 1), "character id")
    |> separator()
    |> label(exchange_request_type(), "request type")
  end

  def exchange_request_type(combinator \\ empty()) do
    choice(combinator, [
      string("1") |> replace(:requested),
      string("2") |> replace(:list),
      string("3") |> replace(:confirmed),
      string("4") |> replace(:cancelled),
      string("5") |> replace(:declined)
    ])
  end
end
