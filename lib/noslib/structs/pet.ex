defmodule Noslib.Pet do
  @type t :: %__MODULE__{
          id: non_neg_integer,
          skin: pos_integer
        }

  defstruct [:id, :skin]

  @empty ["-1"]

  @spec decode(iodata) :: t
  def decode(@empty) do
    %__MODULE__{}
  end

  def decode([id, skin]) do
    %__MODULE__{
      id: id |> String.to_integer(),
      skin: skin |> String.to_integer()
    }
  end

  @spec encode(t) :: iodata
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
