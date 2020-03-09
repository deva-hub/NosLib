defmodule NosLib.CreateSlot do
  @moduledoc """
  CreateSlot is the packet sent to create a new slot.
  ```
  """
  alias NosLib.Character

  @type t :: %__MODULE__{
          index: non_neg_integer,
          name: String.t(),
          sex: String.t(),
          hair_style: String.t(),
          hair_color: String.t()
        }

  defstruct index: 0,
            name: "",
            sex: "female",
            hair_color: "a",
            hair_style: "mauve_taupe"

  def deserialize([name, index, sex, hair_style, hair_color]) do
    %__MODULE__{
      name: name,
      index: index |> String.to_integer(),
      sex: sex |> Character.decode_sex(),
      hair_style: hair_style |> Character.decode_hair_style(),
      hair_color: hair_color |> Character.decode_hair_color()
    }
  end
end

defimpl NosLib.Encoder, for: NosLib.CreateSlot do
  alias NosLib.Character

  def serialize(packet) do
    [
      "char_NEW",
      packet.index |> to_string(),
      packet.sex |> Character.encode_sex(),
      packet.hair_style |> Character.encode_hair_style(),
      packet.hair_color |> Character.encode_hair_color()
    ]
  end
end
