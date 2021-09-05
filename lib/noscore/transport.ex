defmodule Noscore.Transport do
  @callback send(term) :: {:ok, term} | {:error, term}
  @callback recv(term, integer, integer) :: :ok
end
