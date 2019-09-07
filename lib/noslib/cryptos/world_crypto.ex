defmodule NosLib.WorldCrypto do
  @moduledoc """
  This module provides a set of functions used for decoding and decoding World
  packets.
  """
  use Bitwise, only_operators: true

  @char_table [" ", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "n"]

  @spec encrypt(binary) :: binary
  def encrypt(binary) do
    bytes =
      binary
      |> to_charlist
      |> Enum.with_index()

    length = length(bytes)

    data =
      for {b, i} <- bytes,
          into: <<>>,
          do: encrypt_char(b, i, length)

    <<data::binary, 0xFF::size(8)>>
  end

  @type option :: {:session_id, integer}
  @type options :: [option]

  @spec decrypt(binary, options) :: [binary]
  def decrypt(binary, opts \\ []) do
    case Keyword.get(opts, :session_id) do
      nil ->
        <<_::size(8), payload::binary>> = binary

        payload =
          payload
          |> parse_header()
          |> String.split()
          |> Enum.at(1)

        if payload != nil, do: [payload], else: []

      session_id ->
        session_key = session_id &&& 0xFF
        offset = session_key + 0x40 &&& 0xFF
        switch = session_id >>> 6 &&& 0x03

        binarys =
          for <<c <- binary>>, into: <<>> do
            char =
              case switch do
                0 -> c - offset
                1 -> c + offset
                2 -> (c - offset) ^^^ 0xC3
                3 -> (c + offset) ^^^ 0xC3
              end

            <<char::size(8)>>
          end

        binarys
        |> :binary.split(<<0xFF>>, [:global, :trim_all])
        |> Enum.map(<<0xFF>>, &decrypt_session_chunk/1)
    end
  end

  defp parse_header(binary, result \\ "")

  defp parse_header(<<>>, result), do: result
  defp parse_header(<<0xE::size(8), _::binary>>, result), do: result

  defp parse_header(<<char::size(8), rest::binary>>, result) do
    first_byte = char - 0xF
    second_byte = first_byte &&& 0xF0
    first_key = first_byte - second_byte
    second_key = second_byte >>> 0x4

    first =
      case second_key do
        0 -> " "
        1 -> " "
        2 -> "-"
        3 -> "."
        _ -> <<0x2C + second_key::utf8>>
      end

    second =
      case first_key do
        0 -> " "
        1 -> " "
        2 -> "-"
        3 -> "."
        _ -> <<0x2C + first_key::utf8>>
      end

    parse_header(rest, result <> first <> second)
  end

  defp encrypt_char(char, index, _) when rem(index, 0x7E) != 0,
    do: <<(~~~char)>>

  defp encrypt_char(char, index, length) do
    remaining =
      if length - index > 0x7E,
        do: 0x7E,
        else: length - index

    <<remaining::size(8), ~~~char::size(8)>>
  end

  defp decrypt_session_chunk(binary, result \\ [])

  defp decrypt_session_chunk("", result),
    do: result |> Enum.reverse() |> Enum.join()

  defp decrypt_session_chunk(<<byte::size(8), rest::binary>>, result)
       when byte <= 0x7A do
    len = Enum.min([byte, byte_size(rest)])
    {first, second} = String.split_at(rest, len)
    res = for <<c <- first>>, into: "", do: <<c ^^^ 0xFF>>
    decrypt_session_chunk(second, [res | result])
  end

  defp decrypt_session_chunk(<<byte::size(8), rest::binary>>, result) do
    len = byte &&& 0x7F
    {first, second} = parse_session(rest, len)
    decrypt_session_chunk(second, [first | result])
  end

  defp parse_session(bin, len, i \\ 0, result \\ "")

  defp parse_session("", _, _, result),
    do: {result, ""}

  defp parse_session(bin, len, i, result) when i >= len,
    do: {result, bin}

  defp parse_session(bin, len, i, result) do
    <<h::size(4), l::size(4), rest::binary>> = bin

    res =
      cond do
        h != 0 and h != 0xF and (l == 0 or l == 0xF) ->
          Enum.at(@char_table, h - 1)

        l != 0 and l != 0xF and (h == 0 or h == 0xF) ->
          Enum.at(@char_table, l - 1)

        h != 0 and h != 0xF and l != 0 and l != 0xF ->
          Enum.at(@char_table, h - 1) <> Enum.at(@char_table, l - 1)

        true ->
          ""
      end

    case h != 0 and h != 0xF do
      true -> parse_session(rest, len, i + 2, result <> res)
      false -> parse_session(rest, len, i + 1, result <> res)
    end
  end
end
