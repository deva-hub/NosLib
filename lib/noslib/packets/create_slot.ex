defmodule Noslib.CreateSlot do
  @moduledoc """
  CreateSlot is the response to a Ping message.

  ```
  **CreateSlot** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  alias Noslib.Character

  @type t :: %__MODULE__{
          index: non_neg_integer,
          name: String.t(),
          gender: String.t(),
          hair_style: String.t(),
          hair_color: String.t()
        }

  defstruct [:index, :name, :gender, :hair_style, :hair_color]

  def deserialize(packet) do
    slot(%__MODULE__{}, packet)
  end

  defp slot(packet, [name, index | rest]) do
    gender(%{packet | name: name, index: index |> String.to_integer()}, rest)
  end

  defp gender(packet, [gender | rest]) do
    hair(%{packet | gender: gender |> Character.decode_gender()}, rest)
  end

  defp hair(packet, [hair_style, hair_color]) do
    %{
      packet
      | hair_style: hair_style |> Character.decode_hair_style(),
        hair_color: hair_color |> Character.decode_hair_color()
    }
  end
end
