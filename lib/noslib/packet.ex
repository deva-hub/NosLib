defmodule NosLib.Packet do
  @moduledoc false

  def assemble(list),
    do: join(list)

  def assemble(list, fun),
    do: assemble(list, nil, fun)

  def assemble(list, ending, fun) do
    list = Enum.map(list, &fun.(&1))

    [ending | list]
    |> Enum.reverse()
    |> assemble()
  end

  def flatten(list),
    do: join(list, ".")

  def link(list),
    do: join(list, ":")

  def join(list, joiner \\ " ") do
    list
    |> Enum.map(&serialize/1)
    |> Enum.join(joiner)
  end

  def serialize(false), do: "0"
  def serialize(true), do: "1"
  def serialize(""), do: "-"
  def serialize(term), do: term
end
