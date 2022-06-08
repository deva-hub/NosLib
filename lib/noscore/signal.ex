defmodule Noscore.Signal do
  defmacro __using__(_) do
    quote do
      use Phoenix.View, root: "lib/noscore/signals", namespace: Noscore
    end
  end
end
