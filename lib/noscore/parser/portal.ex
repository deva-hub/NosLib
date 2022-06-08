defmodule Noscore.Parser.Gateway do
  import NimbleParsec
  import Noscore.Parser.Battle
  import Noscore.Parser.Bazar
  import Noscore.Parser.Client
  import Noscore.Parser.Helpers

  def key(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "sequence number")
    |> eos()
  end

  def auth(combinator \\ empty()) do
    repeat(
      combinator,
      label(integer(min: 1), "sequence number")
      |> separator()
      |> alphanum_string(min: 1)
      |> lookahead(choice([separator(), eos()]))
    )
  end

  def request(combinator \\ empty()) do
    combinator
    |> label(integer(min: 1), "sequence number")
    |> separator()
    |> choice([
      opcode("mtlist", :mtlist) |> separator() |> multi_target_list(),
      opcode("req_exc", :req_exc) |> separator() |> exchange_request(),
      opcode("c_buy", :c_buy) |> separator() |> character_buy(),
      opcode("c_reg", :c_reg) |> separator() |> character_reg(),
      opcode("c_scalc", :c_scalc) |> separator() |> character_scale_currency(),
      opcode("c_skill", :c_skill) |> separator() |> character_skill(),
      opcode("c_slist", :c_slist) |> separator() |> characters_list(),
      opcode("f_withdraw", :f_withdraw) |> separator() |> family_withdraw(),
      opcode("gop", :gop) |> separator() |> global_options(),
      unidentified()
    ])
    |> eos()
  end

  defp unidentified(combinator \\ empty()) do
    choice(combinator, [
      opcode("f_stash_end", :f_stash_end) |> separator() |> f_stash_end(),
      opcode("c_close", :c_close) |> separator() |> c_close(),
      opcode("lbs", :lbs) |> separator() |> lbs()
    ])
  end
end
