defmodule Noscore.Gateway do
  import Noscore.Utils

  defstruct last_packetid: 0,
            socket: nil,
            transport: nil,
            scheme: :nss

  def handshake(socket, options \\ []) do
    {:ok, struct(__MODULE__, Keyword.merge(options, socket: socket))}
  end

  def send(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    conn.socket.send(crypto.encrypt(frame))
  end

  def recv(conn, timeout \\ 5000) do
    case conn.transport.recv(conn.socket, 0, timeout) do
      {:ok, frame} ->
        decrypt(conn, frame)
        |> Noscore.Parser.gateway_command()
        |> wrap_parse_err()

      {:error, _} = err ->
        err
    end
  end

  defp decrypt(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(frame)
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.SimpleSubstitution
end
