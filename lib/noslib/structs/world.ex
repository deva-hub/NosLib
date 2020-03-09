defmodule NosLib.World do
  @type t :: %__MODULE__{
          id: non_neg_integer,
          name: String.t(),
          group_id: non_neg_integer
        }

  defstruct id: 0,
            name: "",
            group_id: 0

  @empty ["10000.10000.1"]

  def decode(@empty) do
    %__MODULE__{}
  end

  def decode([id, name, group_id]) do
    %__MODULE__{
      id: id |> String.to_integer(),
      name: name,
      group_id: group_id |> String.to_integer()
    }
  end

  def encode do
    @empty
  end

  def encode(%__MODULE__{} = world) do
    [
      world.index |> to_string(),
      world.id |> to_string(),
      world.group_id |> to_string()
    ]
  end
end
