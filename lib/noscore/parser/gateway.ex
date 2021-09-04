defmodule Noscore.Parser.Gateway do
  import NimbleParsec
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def command(combinator \\ empty()) do
    combinator
    |> string("nos0575")
    |> ignore(space())
    |> nos0575()
  end
end
