defmodule Noscore.Parser.Portal do
  import NimbleParsec
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def request(combinator \\ empty()) do
    combinator
    |> opcode("NoS0575", :nos0575)
    |> separator()
    |> nos0575()
    |> eos()
  end
end
