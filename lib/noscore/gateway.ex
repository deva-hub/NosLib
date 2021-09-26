defmodule Noscore.Gateway do
  defstruct last_event_id: 0,
            key: nil,
            state: :closed,
            transport: nil,
            socket: nil,
            scheme: :nss

  def initiate(transport, socket, options \\ []) do
    options =
      Keyword.merge(options,
        socket: socket,
        transport: transport,
        state: :key
      )

    case transport.setopts(socket, active: :once) do
      :ok ->
        {:ok, struct(__MODULE__, options)}

      {:error, _} = error ->
        error
    end
  end

  def send(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    data = data |> IO.iodata_to_binary() |> crypto.encrypt()
    conn.transport.send(conn.socket, data)
  end

  def recv(conn, timeout \\ 5000) do
    case conn.transport.recv(conn.socket, 0, timeout) do
      {:ok, data} -> handle_data(conn, data)
      {:error, error} -> handle_error(conn, error)
    end
  end

  def stream(%__MODULE__{transport: transport, socket: socket} = conn, {tag, socket, data})
      when tag in [:tcp, :ssl] do
    case handle_data(conn, data) do
      {:ok, conn, responses} when conn.state != :closed ->
        case transport.setopts(socket, active: :once) do
          :ok ->
            {:ok, conn, responses}

          {:error, reason} ->
            conn = put_in(conn.state, :closed)
            {:error, conn, reason, responses}
        end

      other ->
        other
    end
  end

  defp handle_data(conn, data) do
    case decode(conn, decrypt(conn, data)) do
      {:ok, conn, responses} ->
        {:ok, conn, Enum.reverse(responses)}

      {:error, conn, reason, responses} ->
        conn = put_in(conn.state, :closed)
        {:error, conn, reason, responses}
    end
  end

  defp handle_error(conn, error) do
    conn = put_in(conn.state, :closed)
    {:error, put_in(conn.state, :closed), error, []}
  end

  defp decrypt(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(data, key: conn.key)
  end

  defp decode(conn, data) when conn.state == :key do
    case Noscore.Parser.gateway_session(data) do
      {:ok, response, _, _, _, _} ->
        conn = put_in(conn.key, response)
        conn = put_in(conn.state, :credentials)
        {:ok, conn, [{:key, response}]}

      {:error, reason, _, _, _, _} ->
        {:error, conn, %Noscore.ParseError{reason: reason}, []}
    end
  end

  defp decode(conn, data) when conn.state == :auth do
    case Noscore.Parser.gateway_auth(data) do
      {:ok, [_, identifier, command_id, password], _, _, _, _} ->
        conn = put_in(conn.last_command_id, command_id)
        conn = put_in(conn.state, :open)
        {:ok, conn, [{:credential, identifier}, {:credential, password}]}

      {:error, reason, _, _, _, _} ->
        {:error, conn, %Noscore.ParseError{reason: reason}, []}
    end
  end

  defp decode(conn, data) do
    case Noscore.Parser.gateway_command(data) do
      {:ok, [command_id | response], _, _, _, _} ->
        conn = put_in(conn.last_command_id, command_id)
        {:ok, conn, [{:event, response}]}

      {:error, reason, rest, _, line, _} ->
        {:error, conn, %Noscore.ParseError{reason: reason, rest: rest, line: line}, []}
    end
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.MonoalphabeticSubstitution
end
