defmodule Noscore.Portal do
  defstruct last_packetid: 0, socket: nil, scheme: :nss

  def new(options) do
    struct(__MODULE__, options)
  end

  def send(conn, frame) do
    crypto = get_crypto(conn)
    conn.socket.send(crypto.encrypt(frame))
  end

  def stream(conn, {:tcp, _, frame}) do
    crypto = get_crypto(conn)
    parse_frame(conn, crypto.decrypt(frame), [])
  end

  defp parse_frame(conn, "", acc) do
    {:ok, conn, acc}
  end

  defp parse_frame(conn, frame, acc) do
    case Noscore.Parser.portal(frame) do
      {:ok, res, rest, _, _, _} ->
        parse_frame(conn, rest, [{:command, res} | acc])

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end

  defp get_crypto(conn) do
    case conn.scheme do
      :ns -> Noscore.Crypto.Clear
      :nss -> Noscore.Crypto.MonoalphabeticSubstitution
    end
  end
end
