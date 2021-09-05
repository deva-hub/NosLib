defmodule Noscore.Gateway do
  defstruct last_packetid: 0, socket: nil, scheme: :nss

  def handshake(socket, options \\ []) do
    {:ok, struct(__MODULE__, Keyword.merge(options, socket: socket))}
  end

  def send(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    conn.socket.send(crypto.encrypt(frame))
  end

  def stream(conn, {:tcp, _, frame}) do
    parse(conn, decrypt(conn, frame))
  end

  def stream(_, _) do
    :unknown
  end

  defp decrypt(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(frame)
  end

  defp parse(conn, frame) do
    case Noscore.Parser.gateway_command(frame) do
      {:ok, res, _, _, _, _} ->
        {:ok, conn, [{:command, res}]}

      {:error, _, rest, _, _, _} ->
        {:data, rest}
    end
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.SimpleSubstitution
end
