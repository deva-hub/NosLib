defmodule Noscore.Parser.Helpers do
  import NimbleParsec

  def alphanum_string(combinator \\ empty(), count_or_opts) do
    ascii_string(combinator, [?a..?z, ?A..?Z, ?0..?9], count_or_opts)
  end

  def integer_string(combinator \\ empty(), count_or_opts) do
    ascii_string(combinator, [?0..?9], count_or_opts)
  end

  def space(combinator \\ empty()) do
    string(combinator, " ")
  end

  def semver(combinator \\ empty()) do
    reduce(
      combinator,
      integer_string(min: 1)
      |> optional(
        string(".")
        |> integer_string(min: 1)
        |> optional(
          string(".")
          |> integer_string(min: 1)
        )
      ),
      {Enum, :join, []}
    )
  end
end
