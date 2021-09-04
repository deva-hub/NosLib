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
    parse_frame(conn, decrypt_frame(conn, frame))
  end

  defp decrypt_frame(conn, frame) do
    crypto = get_crypto(conn)

    case conn.state do
      :init -> crypto.decrypt(frame)
      _ -> crypto.decrypt(frame, key: conn.key)
    end
  end

  defp parse_frame(conn, frame) do
    case conn.state do
      :init ->
        parse_key_frame(conn, frame)

      :auth ->
        parse_auth_frame(conn, frame)

      :established ->
        parse_command_frame(conn, frame)
    end
  end

  defp parse_key_frame(conn, frame) do
    case Noscore.Parser.portal_key(frame) do
      {:ok, res, _, _, _, _} ->
        {:ok, %{conn | state: :auth}, [{:key, res}]}

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end

  defp parse_auth_frame(conn, frame) do
    case Noscore.Parser.portal_auth(frame) do
      {:ok, res, _, _, _, _} ->
        {:ok, %{conn | state: :established}, [{:credential, res}]}

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end

  defp parse_command_frame(conn, frame) do
    case Noscore.Parser.portal_command(frame) do
      {:ok, res, _, _, _, _} ->
        {:ok, conn, [{:command, res}]}

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
