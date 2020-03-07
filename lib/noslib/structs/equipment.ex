defmodule Noslib.Equipment do
  import Noslib.Helpers

  @type t :: %__MODULE__{
          hat: pos_integer | nil,
          armor: pos_integer | nil,
          weapon_skin: pos_integer | nil,
          primary_weapon: pos_integer | nil,
          secondary_weapon: pos_integer | nil,
          mask: pos_integer | nil,
          fairy: pos_integer | nil,
          costume_suit: pos_integer | nil,
          costume_hat: pos_integer | nil
        }

  defstruct [
    :hat,
    :armor,
    :weapon_skin,
    :primary_weapon,
    :secondary_weapon,
    :mask,
    :fairy,
    :costume_suit,
    :costume_hat
  ]

  @spec decode(iodata) :: t
  def decode(packet) do
    packet
    |> Enum.map(&(&1 |> decode_nilable |> String.to_integer()))
    |> Enum.zip([
      :hat,
      :armor,
      :weapon_skin,
      :primary_weapon,
      :secondary_weapon,
      :mask,
      :fairy,
      :costume_suit,
      :costume_hat
    ])
    |> Enum.into(%__MODULE__{})
  end

  @spec encode(t) :: iodata
  def encode(%__MODULE__{} = equipment) do
    [
      equipment.hat |> encode_nilable(),
      equipment.armor |> encode_nilable(),
      equipment.weapon_skin |> encode_nilable(),
      equipment.primary_weapon |> encode_nilable(),
      equipment.secondary_weapon |> encode_nilable(),
      equipment.mask |> encode_nilable(),
      equipment.fairy |> encode_nilable(),
      equipment.costume_suit |> encode_nilable(),
      equipment.costume_hat |> encode_nilable()
    ]
  end
end
