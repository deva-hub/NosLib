defmodule Noscore.Portal do
  defstruct last_packetid: 0,
            key: nil,
            socket: nil,
            scheme: :nss

  def handshake(socket, options \\ []) do
    conn = struct(__MODULE__, Keyword.merge(options, socket: socket))

    with {:ok, conn} <- secure(conn),
         {:ok, credentials} <- recv_auth(conn) do
      {:ok, conn, %{credentials: credentials}}
    end
  end

  defp secure(conn) do
    with {:ok, key} <- recv_key(conn) do
      {:ok, %{conn | key: key}}
    end
  end

  def send(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    conn.socket.send(crypto.encrypt(frame))
  end

  def recv(conn) do
    with {:ok, frame} <- recv_frame(conn) do
      wrap_parse_res(Noscore.Parser.portal_command(frame))
    end
  end

  defp recv_key(conn) do
    with {:ok, frame} <- recv_frame(conn) do
      case wrap_parse_res(Noscore.Parser.portal_key(frame)) do
        {:ok, key} -> {:ok, key}
        {:error, _} -> {:error, :bad_protocol}
      end
    end
  end

  defp recv_auth(conn) do
    with {:ok, frame} <- recv_frame(conn) do
      case wrap_parse_res(Noscore.Parser.portal_auth(frame)) do
        {:ok, creds} -> {:ok, creds}
        {:error, _} -> {:error, :bad_protocol}
      end
    end
  end

  defp recv_frame(conn) do
    with {:ok, frame} <- :gen_tcp.recv(conn.socket, 0) do
      {:ok, decrypt(conn, frame)}
    end
  end

  defp wrap_parse_res(res) do
    case res do
      {:ok, res, _, _, _, _} ->
        {:ok, res}

      {:error, reason, _, _, _, _} ->
        {:error, %Noscore.ParseError{reason: reason}}
    end
  end

  defp decrypt(conn, frame) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(frame, key: conn.key)
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.MonoalphabeticSubstitution
end
