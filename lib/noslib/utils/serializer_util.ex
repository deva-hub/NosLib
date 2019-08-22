defmodule NosLib.SerializerUtil do
  @spec serialize_boolean(boolean) :: non_neg_integer
  def serialize_boolean(true), do: 1
  def serialize_boolean(false), do: 0

  @spec serialize_params(Enum.t()) :: String.t()
  def serialize_params(packet), do: Enum.join(packet, " ")

  @spec serialize_structure(Enum.t()) :: String.t()
  def serialize_structure(packet), do: Enum.join(packet, ".")

  @spec normalize_name(String.t()) :: String.t()
  def normalize_name(""), do: "-"
  def normalize_name("-"), do: "-"
  def normalize_name(string), do: Recase.to_pascal(string)
end
