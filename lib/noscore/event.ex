defmodule Noscore.Event do
  def to_string(iodata) do
    IO.iodata_to_binary(iodata)
  end
end
