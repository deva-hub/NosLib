defmodule Noscore.Utils do
  def wrap_parse_err(res) do
    case res do
      {:ok, res, _, _, _, _} ->
        {:ok, res}

      {:error, reason, _, _, _, _} ->
        {:error, %Noscore.ParseError{reason: reason}}
    end
  end
end
