defmodule Noscore.Parser.Client do
  import NimbleParsec

  def c_close(combinator \\ empty()) do
    combinator
  end

  def gop(combinator \\ empty()) do
    combinator
    |> label(character_option(), "option")
    |> label(integer(min: 1), "active")
  end

  def character_option(combinator \\ empty()) do
    choice(combinator, [
      string("1") |> replace(:exchange_blocked),
      string("2") |> replace(:friend_request_blocked),
      string("3") |> replace(:family_request_blocked),
      string("4") |> replace(:whisper_blocked),
      string("5") |> replace(:group_request_blocked),
      string("8") |> replace(:group_sharing),
      string("9") |> replace(:mouse_aim_lock),
      string("10") |> replace(:hero_chat_blocked),
      string("12") |> replace(:emoticons_blocked),
      string("11") |> replace(:quick_get_up),
      string("13") |> replace(:hp_blocked),
      string("14") |> replace(:buff_blocked),
      string("15") |> replace(:miniland_invite_blocked)
    ])
  end

  def f_stash_end(combinator \\ empty()) do
    combinator
  end

  def lbs(combinator \\ empty()) do
    label(combinator, integer(min: 1), "type")
  end
end
