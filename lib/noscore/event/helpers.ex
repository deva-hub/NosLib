defmodule Noscore.Event.Helpers do
  def nsstring(""), do: "-"
  def nsstring(other) when is_binary(other), do: other

  def nsbool(true), do: nsint(1)
  def nsbool(false), do: nsint(0)

  def nslist(list) when is_list(list), do: Enum.intersperse(list, " ")
  def nstuple(list) when is_list(list), do: Enum.intersperse(list, ":")
  def nsstruct(list) when is_list(list), do: Enum.intersperse(list, ".")

  def nsint(int) when is_integer(int), do: to_string(int)
end
