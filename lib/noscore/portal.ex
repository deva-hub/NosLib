defmodule Noscore.Portal do
  defstruct last_packetid: 0, key: nil, state: :init, socket: nil, scheme: :nss

  def new(options) do
    struct(__MODULE__, options)
  end

  def send(conn, frame) do
    crypto = get_crypto(conn)
    conn.socket.send(crypto.encrypt(frame))
  end

  def stream(conn, {:tcp, _, frame}) do
    parse_frame(conn, decrypt_frame(conn, frame), [])
  end

  defp decrypt_frame(conn, frame) do
    crypto = get_crypto(conn)

    case conn.state do
      :init -> crypto.decrypt(frame)
      _ -> crypto.decrypt(frame, key: conn.key)
    end
  end

  defp parse_frame(conn, "", acc) do
    {:ok, conn, acc}
  end

  defp parse_frame(conn, frame, acc) do
    case conn.state do
      :init ->
        parse_key_frame(conn, frame, acc)

      :auth ->
        parse_auth_frame(conn, frame, acc)

      :established ->
        parse_command_frame(conn, frame, acc)
    end
  end

  defp parse_key_frame(conn, "", acc) do
    {:ok, %{conn | state: :auth}, acc}
  end

  defp parse_key_frame(conn, frame, acc) do
    case Noscore.Parser.portal_key(frame) do
      {:ok, res, rest, _, _, _} ->
        parse_key_frame(conn, rest, [{:key, res} | acc])

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end

  defp parse_auth_frame(conn, "", acc) do
    {:ok, %{conn | state: :established}, acc}
  end

  defp parse_auth_frame(conn, frame, acc) do
    {:ok, res, rest, _, _, _} = Noscore.Parser.portal_auth(frame)
    parse_auth_frame(conn, rest, [{:credential, res} | acc])
  end

  defp parse_command_frame(conn, "", acc) do
    {:ok, conn, acc}
  end

  defp parse_command_frame(conn, frame, acc) do
    case Noscore.Parser.portal_command(frame) do
      {:ok, res, rest, _, _, _} ->
        parse_command_frame(conn, rest, [{:command, res} | acc])

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
