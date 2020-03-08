defmodule NosLib.Helpers do
  @boolean BiMap.new([
             {true, "1"},
             {false, "0"}
           ])

  def decode_boolean(value), do: BiMap.get_key(value)
  def encode_boolean(value), do: BiMap.get(value)

  def decode_nilable("-1", _), do: nil
  def decode_nilable(value, fun), do: fun.(value)

  def encode_nilable(nil), do: "-1"
  def encode_nilable(value), do: value |> to_string

  def encode_enum(enumerable, fun) do
    [fun.() | Enum.map(enumerable, fun)] |> Enum.reverse()
  end

  def decode_enum(enumerable, fun) do
    end_delimiter = fun.()

    enumerable
    |> Enum.reduce_while(fn
      ^end_delimiter, acc ->
        acc

      value, acc ->
        [fun.(value) | acc]
    end)
    |> Enum.reverse()
  end

  def encode_packet(packet) do
    Enum.intersperse(packet, " ")
  end

  def decode_packet(packet) do
    String.split(packet, " ")
  end

  def encode_struct(struct) do
    Enum.intersperse(struct, ".")
  end

  def decode_struct(struct) do
    String.split(struct, ".")
  end

  def encode_tuple(tuple) do
    Enum.intersperse(tuple, ":")
  end

  def decode_tuple(tuple) do
    String.split(tuple, ":")
  end
end
