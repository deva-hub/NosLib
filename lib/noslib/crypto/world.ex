defmodule NosLib.Crypto.World do
  @moduledoc """
  This module provides a set of functions used for decoding and encoding Gateway
  packets.
  """
  use Bitwise, only_operators: true

  @spec encrypt(binary) :: binary
  def encrypt(data) do
    <<encrypt_payload(data)::binary, 0xFF::8>>
  end

  @spec decrypt(binary, integer) :: binary
  def decrypt(data, opts \\ []) do
    case opts[:key_base] do
      nil ->
        decrypt_handshake(data)

      key_base ->
        decrypt_payload(data, key_base)
    end
  end

  defp encrypt_payload(payload) do
    payload = payload |> List.to_charlist() |> Enum.with_index()
    payload_length = length(payload)

    for {byte, index} <- payload, into: <<>> do
      if rem(index, 0x7E) != 0 do
        <<(~~~byte)>>
      else
        <<position_byte_encrypt(index, payload_length)::8, ~~~byte::8>>
      end
    end
  end

  defp position_byte_encrypt(index, len) do
    if(len - index > 0x7E, do: 0x7E, else: len - index)
  end

  defp decrypt_handshake(payload, result \\ [])

  defp decrypt_handshake(<<>>, result) do
    result
    |> Enum.reverse()
    |> Enum.join()
  end

  defp decrypt_handshake(<<0xE::8, _::binary>>, result) do
    decrypt_handshake(<<>>, result)
  end

  defp decrypt_handshake(<<char::8, rest::binary>>, result) do
    first_byte = char - 0xF
    second_byte = first_byte &&& 0xF0

    first_char = byte_conversion(first_byte >>> 0x4)
    second_char = byte_conversion(first_byte - second_byte)

    decrypt_handshake(rest, [second_char, first_char | result])
  end

  defp byte_conversion(0), do: " "
  defp byte_conversion(1), do: " "
  defp byte_conversion(2), do: "-"
  defp byte_conversion(3), do: "."
  defp byte_conversion(key), do: <<0x2C + key::utf8>>

  defp decrypt_payload(binary, key) do
    session_key = key &&& 0xFF
    offset = session_key + 0x40 &&& 0xFF
    switch = key >>> 6 &&& 0x03

    binary
    |> payload_permutation(offset, switch)
    |> :binary.split(<<0xFF>>, [:global, :trim_all])
    |> Enum.map(&decrypt_subpacket(&1))
    |> Enum.join()
  end

  defp payload_permutation(binary, offset, switch) do
    for <<byte <- binary>>, into: <<>> do
      <<byte_permutation(switch, byte, offset)>>
    end
  end

  defp byte_permutation(0, byte, offset), do: byte - offset
  defp byte_permutation(1, byte, offset), do: byte + offset
  defp byte_permutation(2, byte, offset), do: (byte - offset) ^^^ 0xC3
  defp byte_permutation(3, byte, offset), do: (byte + offset) ^^^ 0xC3

  defp decrypt_subpacket(binary, result \\ [])

  defp decrypt_subpacket(<<byte::8, rest::binary>>, result) when byte <= 0x7A do
    len = Enum.min([byte, byte_size(rest)])
    {first, second} = String.split_at(rest, len)
    res = for <<byte <- first>>, into: "", do: <<byte ^^^ 0xFF>>
    decrypt_subpacket(second, [res | result])
  end

  defp decrypt_subpacket(<<byte::8, rest::binary>>, result) do
    {first, rest} = decrypt_subpacket_chunk(rest, byte &&& 0x7F)
    decrypt_subpacket(rest, [first | result])
  end

  defp decrypt_subpacket(<<>>, result) do
    result
    |> Enum.reverse()
    |> Enum.join()
  end

  defp decrypt_subpacket_chunk(binary, len, i \\ 0, result \\ [])

  defp decrypt_subpacket_chunk(binary, len, i, result) when i >= len do
    case binary do
      <<>> ->
        {Enum.join(result), ""}

      <<h::4, l::4, rest::binary>> ->
        res = byte_permutation(h, l)

        if h != 0 and h != 0xF do
          decrypt_subpacket_chunk(rest, len, i + 2, [result | res])
        else
          decrypt_subpacket_chunk(rest, len, i + 1, [result | res])
        end
    end
  end

  defp decrypt_subpacket_chunk(binary, _, _, result) do
    {Enum.join(result), binary}
  end

  @world_permutation_table [" ", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "n"]

  defp byte_permutation(h, l) when h != 0 and h != 0xF and (l == 0 or l == 0xF) do
    Enum.at(@world_permutation_table, h - 1)
  end

  defp byte_permutation(h, l) when l != 0 and l != 0xF and (h == 0 or h == 0xF) do
    Enum.at(@world_permutation_table, l - 1)
  end

  defp byte_permutation(h, l) when h != 0 and h != 0xF and l != 0 and l != 0xF do
    Enum.at(@world_permutation_table, h - 1) <> Enum.at(@world_permutation_table, l - 1)
  end

  defp byte_permutation(_, _) do
    ""
  end
end
