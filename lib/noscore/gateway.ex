defmodule Noscore.Gateway do
  alias Noscore.Gateway.Crypto

  defstruct sequence: 0,
            key: nil,
            state: :closed,
            transport: nil,
            serializer: nil,
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

  def send(conn, msg) do
    conn.transport.send(
      conn.socket,
      Crypto.encrypt(conn, msg)
    )
  end

  def recv(conn, timeout \\ 5000) do
    case conn.transport.recv(conn.socket, 0, timeout) do
      {:ok, data} -> handle_data(conn, data)
      {:error, error} -> handle_error(conn, error)
    end
  end

  def stream(%__MODULE__{} = conn, {tag, _, data})
      when tag in [:tcp, :ssl] do
    case handle_data(conn, data) do
      {:ok, %{state: :closed} = conn, responses} ->
        handle_pull(conn, responses)

      other ->
        other
    end
  end

  defp handle_data(conn, data) do
    case handle_decode(conn, Crypto.decrypt(conn, data)) do
      {:ok, conn, responses} ->
        {:ok, conn, Enum.reverse(responses)}

      {:error, conn, reason, responses} ->
        {:error, put_in(conn.state, :closed), reason, responses}
    end
  end

  defp handle_pull(conn, responses) do
    case conn.transport.setopts(conn.socket, active: :once) do
      :ok ->
        {:ok, conn, responses}

      {:error, reason} ->
        {:error, put_in(conn.state, :closed), reason, responses}
    end
  end

  defp handle_error(conn, error) do
    {:error, put_in(conn.state, :closed), error, []}
  end

  defp handle_decode(%{state: :key} = conn, data) do
    case Noscore.Parser.gateway_session(data) do
      {:ok, data, _, _, _, _} ->
        handle_key(conn, data)

      {:error, reason, rest, _, line, _} ->
        Noscore.Utils.wrap_parse_err(conn, reason, rest, line)
    end
  end

  defp handle_decode(%{state: :auth} = conn, data) do
    {:ok, responses, _, _, _, _} = Noscore.Parser.gateway_auth(data)
    handle_auth(conn, responses)
  end

  defp handle_decode(conn, data) do
    case Noscore.Parser.gateway_body(data) do
      {:ok, response, _, _, _, _} ->
        handle_command(conn, response)

      {:error, reason, rest, _, line, _} ->
        Noscore.Utils.wrap_parse_err(conn, reason, rest, line)
    end
  end

  defp handle_key(conn, response) do
    {:ok, put_key(conn, response), [{:key, response}]}
  end

  defp handle_auth(conn, responses, credentials \\ [])

  defp handle_auth(conn, [], credentials) do
    {:ok, conn, credentials}
  end

  defp handle_auth(conn, [command_id, credential | rest], credentials) do
    credentials = [{:credential, command_id, credential} | credentials]
    handle_auth(pull_continue(conn, command_id), rest, credentials)
  end

  defp handle_command(conn, [command_id | response]) do
    {:ok, %{conn | sequence: command_id}, [{:frame, response}]}
  end

  defp pull_continue(conn, command_id) do
    %{conn | sequence: command_id, state: :open}
  end

  defp put_key(conn, key) do
    %{conn | state: :credentials, key: key}
  end
end

defmodule Noscore.Gateway.Crypto do
  def encrypt(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    data |> IO.iodata_to_binary() |> crypto.encrypt()
  end

  def decrypt(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(data, key: conn.key)
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.MonoalphabeticSubstitution
end
