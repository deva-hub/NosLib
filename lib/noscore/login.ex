defmodule Noscore.Login do
  defstruct last_packetid: 0, socket: nil

  def new do
    %__MODULE__{}
  end

  def stream(conn, {:tcp, _, frame}) do
    parse_frame(conn, frame, [])
  end

  defp parse_frame(conn, "", acc) do
    {:ok, conn, acc}
  end

  defp parse_frame(conn, frame, acc) do
    case Noscore.Parser.login(frame) do
      {:ok, res, rest, _, _, _} ->
        parse_frame(conn, rest, [{:command, res} | acc])

      {:error, _, _, _, _, _} ->
        :unknown
    end
  end
end
