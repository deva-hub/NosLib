defmodule Noscore.ParseError do
  defexception [:reason, :rest, :line, :col, :cursor]

  def message(%__MODULE__{reason: reason}) do
    reason
  end
end
