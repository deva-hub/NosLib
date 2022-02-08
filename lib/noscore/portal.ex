defmodule Noscore.Portal do
  alias Noscore.Portal.Crypto

  defstruct socket: nil,
            state: :closed,
            transport: nil,
            scheme: :nss

  def initiate(transport, socket, options \\ []) do
    options =
      Keyword.merge(options,
        socket: socket,
        transport: transport,
        state: :open
      )

    case transport.setopts(socket, active: :once) do
      :ok ->
        {:ok, struct(__MODULE__, options)}

      {:error, _} = error ->
        error
    end
  end

  def send(conn, data) do
    conn.transport.send(
      conn.socket,
      Crypto.encrypt(conn, data)
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

  defp handle_decode(conn, data) do
    case Noscore.Parser.portal_command(data) do
      {:ok, response, _, _, _, _} ->
        handle_event(conn, response)

      {:error, reason, rest, _, line, _} ->
        Noscore.Utils.wrap_parse_err(conn, reason, rest, line)
    end
  end

  defp handle_event(conn, response) do
    {:ok, conn, [{:event, response}]}
  end
end

defmodule Noscore.Portal.Crypto do
  def encrypt(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    data |> IO.iodata_to_binary() |> crypto.encrypt()
  end

  def decrypt(conn, data) do
    crypto = scheme_to_crypto(conn.scheme)
    crypto.decrypt(data)
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.SimpleSubstitution
end
