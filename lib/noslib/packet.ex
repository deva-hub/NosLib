defmodule NosLib.Packet do
  @moduledoc false

  @spec assemble([binary]) :: binary
  def assemble(list) do
    join(list)
  end

  @spec assemble([binary], function) :: binary
  def assemble(list, fun) do
    assemble(list, nil, fun)
  end

  @spec assemble([binary], STring.t() | nil, function) :: binary
  def assemble(list, ending, fun) do
    list = Enum.map(list, &fun.(&1))

    [ending | list]
    |> Enum.reverse()
    |> assemble()
  end

  @spec flatten([binary]) :: binary
  def flatten(list), do: join(list, ".")

  @spec link([binary]) :: binary
  def link(list), do: join(list, ":")

  @spec join([binary]) :: binary
  def join(list, joiner \\ " ") do
    list
    |> Enum.map(&serialize/1)
    |> Enum.join(joiner)
  end

  @spec serialize(term) :: binary
  def serialize(false), do: "0"
  def serialize(true), do: "1"
  def serialize(""), do: "-"
  def serialize(term), do: term
end
