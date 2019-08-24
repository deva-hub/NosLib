defmodule NosLib.Packet do
  @spec assemble([String.t()]) :: String.t()
  def assemble(list) do
    join(list)
  end

  @spec assemble([String.t()], function) :: String.t()
  def assemble(list, fun) do
    assemble(list, nil, fun)
  end

  @spec assemble([String.t()], STring.t() | nil, function) :: String.t()
  def assemble(list, ending, fun) do
    list = Enum.map(list, &fun.(&1))

    [ending | list]
    |> Enum.reverse()
    |> assemble()
  end

  @spec flatten([String.t()]) :: String.t()
  def flatten(list), do: join(list, ".")

  @spec link([String.t()]) :: String.t()
  def link(list), do: join(list, ":")

  @spec join([String.t()]) :: String.t()
  def join(list, joiner \\ " ") do
    list
    |> Enum.map(&serialize/1)
    |> Enum.join(joiner)
  end

  @spec serialize(term) :: String.t()
  def serialize(false), do: "0"
  def serialize(true), do: "1"
  def serialize(""), do: "-"
  def serialize(term), do: term
end
