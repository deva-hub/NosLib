defmodule Noscore.Gateway do
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
    parse_frame(conn, crypto.decrypt(frame))
  end

  defp parse_frame(conn, frame) do
    case Noscore.Parser.gateway_command(frame) do
      {:ok, res, _, _, _, _} ->
        {:ok, conn, [{:command, res}]}

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end

  defp get_crypto(conn) do
    case conn.scheme do
      :ns -> Noscore.Crypto.Clear
      :nss -> Noscore.Crypto.SimpleSubstitution
    end
  end
end
