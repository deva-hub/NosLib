defmodule Noscore.Utils do
  def wrap_parse_err(conn, reason, rest, line) do
    err = %Noscore.ParseError{
      reason: reason,
      rest: rest,
      line: line
    }

    {:error, conn, err, []}
  end
end
