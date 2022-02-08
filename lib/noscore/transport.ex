defmodule Noscore.Transport do
  @callback send(term, term) :: :ok | {:error, term}
  @callback recv(term, integer, integer) :: :ok | {:error, term}
  @callback setopts(term, :inet.socket_options()) :: :ok | {:error, :inet.posix()}
end
