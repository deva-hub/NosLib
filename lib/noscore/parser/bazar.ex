defmodule Noscore.Parser.Bazar do
  import NimbleParsec
  import Noscore.Parser.Helpers

  def character_blist(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "slot")
    |> separator()
    |> label(filter_type(), "filter_type")
    |> separator()
    |> label(integer(min: 1), "subfilter_type")
    |> separator()
    |> label(integer(min: 1), "level_filter")
    |> separator()
    |> label(integer(min: 1), "rare_filter")
    |> separator()
    |> label(integer(min: 1), "upgrade_filter")
    |> separator()
    |> label(integer(min: 1), "order_filter")
    |> separator()
    |> ignore(integer(min: 1))
    |> separator()
    |> label(integer(min: 1), "item_vnum_filter")
    |> separator()
  end

  def filter_type(combinator \\ empty()) do
    choice(combinator, [
      string("0") |> replace(:default),
      string("1") |> replace(:weapon),
      string("2") |> replace(:armor),
      string("3") |> replace(:equipment),
      string("4") |> replace(:jewelery),
      string("5") |> replace(:specialist),
      string("6") |> replace(:pet),
      string("7") |> replace(:npc),
      string("8") |> replace(:shell),
      string("9") |> replace(:main),
      string("10") |> replace(:usable),
      string("11") |> replace(:other),
      string("12") |> replace(:vehicle)
    ])
  end

  def character_buy(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "id")
    |> separator()
    |> label(integer(min: 1), "vnum")
    |> separator()
    |> label(integer(min: 1), "amount")
    |> separator()
    |> label(integer(min: 1), "price")
    |> separator()
  end

  def character_reg(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "type")
    |> separator()
    |> label(integer(min: 1), "inventory")
    |> separator()
    |> label(integer(min: 1), "slot")
    |> separator()
    |> label(integer(min: 1), "durability")
    |> separator()
    |> label(integer(min: 1), "package")
    |> separator()
    |> label(integer(min: 1), "amount")
    |> separator()
    |> label(integer(min: 1), "price")
    |> separator()
    |> label(integer(min: 1), "taxe")
    |> separator()
    |> label(integer(min: 1), "medal_used")
    |> separator()
  end

  def character_scale_currency(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "id")
    |> separator()
    |> label(integer(min: 1), "vnum")
    |> separator()
    |> label(integer(min: 1), "amount")
    |> separator()
    |> label(integer(min: 1), "max_amount")
    |> separator()
    |> label(integer(min: 1), "price")
    |> separator()
  end

  def character_skill(combinator \\ empty()) do
    combinator
  end

  def characters_list(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "index")
    |> separator()
    |> label(integer(min: 1), "filter")
    |> separator()
  end

  def family_withdraw(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "slot")
    |> separator()
    |> label(integer(min: 1), "amount")
    |> separator()
  end
end
