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

  def header(combinator \\ empty(), header) do
    label(combinator, string(header), "header")
  end

  def separator(combinator \\ empty()) do
    ignore(combinator, space())
  end
end
