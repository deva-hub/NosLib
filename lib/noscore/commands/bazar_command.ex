defmodule Noscore.BazarCommand do
  import NimbleParsec

  def c_blist(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "slot")
    |> label(filter_type(), "filter_type")
    |> label(integer(min: 1), "subfilter_type")
    |> label(integer(min: 1), "level_filter")
    |> label(integer(min: 1), "rare_filter")
    |> label(integer(min: 1), "upgrade_filter")
    |> label(integer(min: 1), "order_filter")
    |> ignore(integer(min: 1))
    |> label(integer(min: 1), "item_vnum_filter")
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

  def c_buy(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "id")
    |> label(integer(min: 1), "vnum")
    |> label(integer(min: 1), "amount")
    |> label(integer(min: 1), "price")
  end

  def c_reg(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "type")
    |> label(integer(min: 1), "inventory")
    |> label(integer(min: 1), "slot")
    |> label(integer(min: 1), "durability")
    |> label(integer(min: 1), "package")
    |> label(integer(min: 1), "amount")
    |> label(integer(min: 1), "price")
    |> label(integer(min: 1), "taxe")
    |> label(integer(min: 1), "medal_used")
  end

  def c_scalc(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "id")
    |> label(integer(min: 1), "vnum")
    |> label(integer(min: 1), "amount")
    |> label(integer(min: 1), "max_amount")
    |> label(integer(min: 1), "price")
  end

  def c_skill(combinator \\ empty()) do
    combinator
  end

  def c_slist(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "index")
    |> label(integer(min: 1), "filter")
  end

  def f_withdraw(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "slot")
    |> label(integer(min: 1), "amount")
  end
end
