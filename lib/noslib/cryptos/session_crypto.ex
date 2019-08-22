defmodule NosLib.SessionCrypto do
  @moduledoc """
  This module provides a set of cryptographic functions
  used for the World protocol.
  """

  use Bitwise, only_operators: true

  @char_table [" ", "-", ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "n"]

  @doc """
  Encrypt data to binary.
  """
  @spec encrypt(String.t()) :: binary
  def encrypt(binary) do
    bytes =
      binary
      |> to_charlist
      |> Enum.with_index()

    length = length(bytes)
    data = for {b, i} <- bytes, into: <<>>, do: encrypt_char(b, i, length)
    <<data::binary, 0xFF::size(8)>>
  rescue
    _e in ArgumentError ->
      reraise NosLib.CryptoError, __STACKTRACE__
  end

  @doc """
  Decrypt a binary packet to a list of world packet.
  """
  @spec decrypt(binary, String.t()) :: [binary]
  def decrypt(packet, client_id) do
    session_key = client_id &&& 0xFF
    offset = session_key + 0x40 &&& 0xFF
    switch = client_id >>> 6 &&& 0x03

    binarys =
      for <<c <- packet>>, into: <<>> do
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
    |> Enum.map(&decrypt_packet/1)
    |> Stream.map(&String.split(&1, " ", parts: 2))
    |> Enum.map(fn [l, r] -> {String.to_integer(l), r} end)
  rescue
    _e in ArgumentError ->
      reraise NosLib.CryptoError, __STACKTRACE__
  end

  #
  # Private functions
  #

  @spec encrypt_char(char, integer, integer) :: binary
  defp encrypt_char(char, index, _) when rem(index, 0x7E) != 0, do: <<(~~~char)>>

  defp encrypt_char(char, index, length) do
    remaining = if length - index > 0x7E, do: 0x7E, else: length - index
    <<remaining::size(8), ~~~char::size(8)>>
  end

  @spec decrypt_packet(binary, list) :: String.t()
  defp decrypt_packet(binary, result \\ [])
  defp decrypt_packet("", result), do: result |> Enum.reverse() |> Enum.join()

  defp decrypt_packet(<<byte::size(8), rest::binary>>, result) when byte <= 0x7A do
    len = Enum.min([byte, byte_size(rest)])
    {first, second} = String.split_at(rest, len)
    res = for <<c <- first>>, into: "", do: <<c ^^^ 0xFF>>
    decrypt_packet(second, [res | result])
  end

  defp decrypt_packet(<<byte::size(8), rest::binary>>, result) do
    len = byte &&& 0x7F
    {first, second} = decrypt_packet_chunk(rest, len)
    decrypt_packet(second, [first | result])
  end

  @spec decrypt_packet_chunk(binary, integer, binary) :: {binary, binary}
  defp decrypt_packet_chunk(bin, len, i \\ 0, result \\ "")
  defp decrypt_packet_chunk("", _, _, result), do: {result, ""}
  defp decrypt_packet_chunk(bin, len, i, result) when i >= len, do: {result, bin}

  defp decrypt_packet_chunk(bin, len, i, result) do
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
      true -> decrypt_packet_chunk(rest, len, i + 2, result <> res)
      false -> decrypt_packet_chunk(rest, len, i + 1, result <> res)
    end
  end
end
