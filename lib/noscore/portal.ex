defmodule Noscore.Portal do
  import Noscore.Utils

  defstruct last_packetid: 0,
            key: nil,
            transport: nil,
            socket: nil,
            scheme: :nss

  def handshake(socket, options \\ []) do
    conn = struct(__MODULE__, Keyword.merge(options, socket: socket))

    with {:ok, conn} <- secure(conn),
         {:ok, credentials} <- recv_auth(conn) do
      {:ok, conn, %{credentials: credentials}}
    else
      {:error, _} -> {:error, :bad_protocol}
    end
  end

  defp secure(conn) do
    case recv_key(conn) do
      {:ok, key} ->
        {:ok, %{conn | key: key}}

      {:error, _} = err ->
        err
    end
  end

  def send(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    conn.socket.send(crypto.encrypt(frame))
  end

  def recv(conn) do
    case recv_frame(conn) do
      {:ok, frame} ->
        wrap_parse_err(Noscore.Parser.portal_command(frame))

      {:error, _} = err ->
        err
    end
  end

  defp recv_key(conn, timeout \\ 5000) do
    case recv_frame(conn, timeout) do
      {:ok, frame} ->
        wrap_parse_err(Noscore.Parser.portal_key(frame))

      {:error, _} = err ->
        err
    end
  end

  defp recv_auth(conn, timeout \\ 5000) do
    case recv_frame(conn, timeout) do
      {:ok, frame} ->
        wrap_parse_err(Noscore.Parser.portal_auth(frame))

      {:error, _} = err ->
        err
    end
  end

  defp recv_frame(conn, timeout \\ 5000) do
    case conn.transport.recv(conn.socket, 0, timeout) do
      {:ok, frame} -> {:ok, decrypt(conn, frame)}
      {:error, _} = err -> err
    end
  end

  defp decrypt(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(frame, key: conn.key)
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.MonoalphabeticSubstitution
end
