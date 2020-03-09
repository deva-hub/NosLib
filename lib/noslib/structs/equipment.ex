defmodule NosLib.Equipment do
  import NosLib.Helpers

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

  defstruct hat: nil,
            armor: nil,
            weapon_skin: nil,
            primary_weapon: nil,
            secondary_weapon: nil,
            mask: nil,
            fairy: nil,
            costume_suit: nil,
            costume_hat: nil

  def decode([
        hat,
        armor,
        weapon_skin,
        primary_weapon,
        secondary_weapon,
        mask,
        fairy,
        costume_suit,
        costume_hat
      ]) do
    %__MODULE__{
      hat: hat |> decode_nilable(&String.to_integer/1),
      armor: armor |> decode_nilable(&String.to_integer/1),
      weapon_skin: weapon_skin |> decode_nilable(&String.to_integer/1),
      primary_weapon: primary_weapon |> decode_nilable(&String.to_integer/1),
      secondary_weapon: secondary_weapon |> decode_nilable(&String.to_integer/1),
      mask: mask |> decode_nilable(&String.to_integer/1),
      fairy: fairy |> decode_nilable(&String.to_integer/1),
      costume_suit: costume_suit |> decode_nilable(&String.to_integer/1),
      costume_hat: costume_hat |> decode_nilable(&String.to_integer/1)
    }
  end

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
