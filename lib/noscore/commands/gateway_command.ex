defmodule Noscore.GatewayCommand do
  import NimbleParsec
  import Noscore.ProtocolHelpers

  def nos0575(combinator \\ empty()) do
    combinator
    |> ignore(alphanum_string(min: 1))
    |> ignore(space())
    |> label(alphanum_string(min: 1), "username")
    |> ignore(space())
    |> label(alphanum_string(min: 1) |> map({__MODULE__, :normalize_password, []}), "password")
    |> ignore(space())
    |> ignore(alphanum_string(min: 1))
    |> ignore(space())
    |> label(semver() |> map({__MODULE__, :normalize_version, []}), "version")
  end

  @nostale_semver_regex ~r/(\d*)\.(\d*)\.(\d*)\.(\d*)/

  def normalize_version(version) do
    Regex.replace(@nostale_semver_regex, version, "\\1.\\2.\\3+\\4")
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
end
