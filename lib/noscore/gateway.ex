defmodule Noscore.Gateway do
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
    crypto.decrypt(data)
  end

  defp decode(conn, data) do
    case Noscore.Parser.gateway_command(data) do
      {:ok, response, _, _, _, _} ->
        {:ok, conn, [{:event, response}]}

      {:error, reason, _, _, _, _} ->
        {:error, conn, %Noscore.ParseError{reason: reason}, []}
    end
  end

  defp scheme_to_crypto(:ns), do: Noscore.Crypto.Clear
  defp scheme_to_crypto(:nss), do: Noscore.Crypto.SimpleSubstitution
end
