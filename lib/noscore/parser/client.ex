defmodule Noscore.Parser.Client do
  import NimbleParsec
  import Noscore.Parser.Helpers

  def nos0575(combinator \\ empty()) do
    combinator
    |> ignore(alphanum_string(min: 1))
    |> separator()
    |> label(alphanum_string(min: 1), "username")
    |> separator()
    |> label(password(), "password")
    |> separator()
    |> ignore(alphanum_string(min: 1))
    |> separator()
    |> label(version(), "version")
  end

  def password(combinator \\ empty()) do
    combinator
    |> alphanum_string(min: 1)
    |> map({__MODULE__, :normalize_password, []})
  end

  def version(combinator \\ empty()) do
    reduce(
      combinator,
      integer_string(min: 1)
      |> string(".")
      |> integer_string(min: 1)
      |> string(".")
      |> integer_string(min: 1)
      |> replace(string("."), "+")
      |> integer_string(min: 1),
      {Enum, :join, []}
    )
  end

  def normalize_password(cipher_password) do
    :crypto.hash(:sha512, decrypt_password(cipher_password))
  end

  def decrypt_password(password) do
    password
    |> slice_password_padding()
    |> String.codepoints()
    |> Enum.take_every(2)
    |> Enum.chunk_every(2)
    |> Enum.map(&(&1 |> Enum.join() |> String.to_integer(16)))
    |> to_string()
  end

  def slice_password_padding(password) do
    case password |> String.length() |> rem(2) do
      0 -> String.slice(password, 3..-1)
      1 -> String.slice(password, 4..-1)
    end
  end

  def global_options(combinator \\ empty()) do
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

  def c_close(combinator \\ empty()) do
    combinator
  end

  def f_stash_end(combinator \\ empty()) do
    combinator
  end

  def lbs(combinator \\ empty()) do
    label(combinator, integer(min: 1), "type")
  end
end
