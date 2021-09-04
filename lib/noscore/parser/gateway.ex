defmodule Noscore.Parser.Gateway do
  import NimbleParsec
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def command(combinator \\ empty()) do
    combinator
    |> header("nos0575")
    |> separator()
    |> nos0575()
    |> eos()
  end
end
