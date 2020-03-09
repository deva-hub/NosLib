defmodule NosLib.Pet do
  @type t :: %__MODULE__{
          id: non_neg_integer,
          skin_id: non_neg_integer
        }

  defstruct id: 0,
            skin_id: 0

  @empty ["-1"]

  def decode(@empty) do
    %__MODULE__{}
  end

  def decode([id, skin_id]) do
    %__MODULE__{
      id: id |> String.to_integer(),
      skin_id: skin_id |> String.to_integer()
    }
  end

  def encode do
    @empty
  end

  def encode(%__MODULE__{} = pet) do
    [
      pet.skin_id |> to_string(),
      pet.id |> to_string()
    ]
  end
end
