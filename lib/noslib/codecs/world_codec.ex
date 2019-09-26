defmodule NosLib.WorldCodec do
  @moduledoc """
  This module provides a set of functions used for decoding and decoding World
  packets.
  """
  use Bitwise, only_operators: true

  @char_table [" ", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "n"]

  @spec encode(iodata) :: binary
  def encode(input) when is_list(input),
    do: encode(IO.iodata_to_binary(input))

  @spec encode(String.t()) :: binary
  def encode(input) do
    bytes = binary_to_indexed_bytes(input)
    data = encode_payload(bytes)
    <<data::binary, 0xFF::size(8)>>
  end

  defp binary_to_indexed_bytes(input) do
    input
    |> String.to_charlist()
    |> Enum.with_index()
  end

  defp encode_payload(bytes) do
    bytes_length = length(bytes)

    for {b, i} <- bytes,
        into: <<>>,
        do: encode_byte(b, i, bytes_length)
  end

  defp encode_byte(char, index, _length)
       when rem(index, 0x7E) != 0,
       do: <<(~~~char)>>

  defp encode_byte(char, index, length) do
    remaining =
      if length - index > 0x7E,
        do: 0x7E,
        else: length - index

    <<remaining::size(8), ~~~char::size(8)>>
  end

  @type option :: {:session_id, integer}
  @type options :: [option]

  @spec decode(binary, options) :: iodata
  def decode(input, opts \\ []) do
    case Keyword.get(opts, :session_id) do
      nil ->
        decode_header(input)

      session_id ->
        decode_packet(input, session_id)
    end
  end

  defp decode_header(binary) do
    <<_::size(8), payload::binary>> = binary
    decode_header_payload(payload)
  end

  defp decode_header_payload(binary, result \\ "")

  defp decode_header_payload(<<0xE::size(8), _::binary>>, result),
    do: decode_header_payload(<<>>, result)

  defp decode_header_payload(<<char::size(8), rest::binary>>, result) do
    first_byte = char - 0xF
    second_byte = first_byte &&& 0xF0

    first = decodeh_header_first(second_byte)
    second = decodeh_header_second(first_byte, second_byte)

    decode_header_payload(rest, [first, second | result])
  end

  defp decode_header_payload(<<>>, result) do
    result
    |> Enum.reverse()
    |> Enum.join()
    |> String.split()
  end

  defp decodeh_header_first(second_byte) do
    case second_byte >>> 0x4 do
      0 -> " "
      1 -> " "
      2 -> "-"
      3 -> "."
      key -> <<0x2C + key::utf8>>
    end
  end

  defp decodeh_header_second(first_byte, second_byte) do
    case first_byte - second_byte do
      0 -> " "
      1 -> " "
      2 -> "-"
      3 -> "."
      key -> <<0x2C + key::utf8>>
    end
  end

  defp decode_packet(input, session_id) do
    session_key = session_id &&& 0xFF
    offset = session_key + 0x40 &&& 0xFF
    switch = session_id >>> 6 &&& 0x03
    data = decode_packet_payload(input, offset, switch)

    data
    |> :binary.split(<<0xFF>>, [:global, :trim_all])
    |> Enum.map(&decode_subpacket/1)
    |> Enum.map(&String.split(&1, " ", parts: 2))
  end

  defp decode_packet_payload(input, offset, switch) do
    for <<byte <- input>>, into: <<>> do
      char =
        case switch do
          0 -> byte - offset
          1 -> byte + offset
          2 -> (byte - offset) ^^^ 0xC3
          3 -> (byte + offset) ^^^ 0xC3
        end

      <<char::size(8)>>
    end
  end

  defp decode_subpacket(binary, result \\ [])

  defp decode_subpacket(<<byte::size(8), rest::binary>>, result)
       when byte <= 0x7A do
    len = Enum.min([byte, byte_size(rest)])
    {first, second} = String.split_at(rest, len)
    res = for <<byte <- first>>, into: "", do: <<byte ^^^ 0xFF>>
    decode_subpacket(second, [res | result])
  end

  defp decode_subpacket(<<byte::size(8), rest::binary>>, result) do
    len = byte &&& 0x7F
    {first, second} = decode_subpacket_data(rest, len)
    decode_subpacket(second, [first | result])
  end

  defp decode_subpacket(<<>>, result) do
    result
    |> Enum.reverse()
    |> Enum.join()
  end

  defp decode_subpacket_data(bin, len, i \\ 0, result \\ [])

  defp decode_subpacket_data("", _, _, result),
    do: {Enum.join(result), ""}

  defp decode_subpacket_data(bin, len, i, result) when i >= len,
    do: {Enum.join(result), bin}

  defp decode_subpacket_data(bin, len, i, result) do
    <<h::size(4), l::size(4), rest::binary>> = bin

    res = apply_matrix_conversion(h, l)

    if h != 0 and h != 0xF,
      do: decode_subpacket_data(rest, len, i + 2, [result | res]),
      else: decode_subpacket_data(rest, len, i + 1, [result | res])
  end

  defp apply_matrix_conversion(h, l)
       when h != 0 and h != 0xF and (l == 0 or l == 0xF),
       do: Enum.at(@char_table, h - 1)

  defp apply_matrix_conversion(h, l)
       when l != 0 and l != 0xF and (h == 0 or h == 0xF),
       do: Enum.at(@char_table, l - 1)

  defp apply_matrix_conversion(h, l)
       when h != 0 and h != 0xF and l != 0 and l != 0xF,
       do: Enum.at(@char_table, h - 1) <> Enum.at(@char_table, l - 1)

  defp apply_matrix_conversion(_h, _l),
    do: ""
end
