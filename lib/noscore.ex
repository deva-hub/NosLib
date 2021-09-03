defmodule Noscore do
  def build(header, packet) do
    Enum.join([header | packet], " ")
  end
end
