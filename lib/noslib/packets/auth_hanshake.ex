defmodule Noslib.AuthHandshake do
  @moduledoc """
  A wrapper for Nostale's `AuthHandshake` message.
  """

  defstruct [
    :username,
    :password,
    :client_vsn,
    :client_hash
  ]

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t(),
          client_vsn: String.t(),
          client_hash: String.t()
        }

  @spec new(String.t(), String.t(), String.t(), String.t()) :: t
  def deserialize([username, password, client_vsn, client_hash]) do
    %__MODULE__{
      username: username,
      password: decode_password(password),
      client_vsn: decode_client_vsn(client_vsn),
      client_hash: client_hash
    }
  end

  def decode_password(password) do
    password
    |> password_slice()
    |> String.codepoints()
    |> Enum.take_every(2)
    |> Enum.chunk_every(2)
    |> Enum.map(&(Enum.join(&1) |> String.to_integer(16)))
    |> to_string()
  end

  defp password_slice(password) do
    case password_slice_position(password) do
      0 -> String.slice(password, 3..-1)
      1 -> String.slice(password, 4..-1)
    end
  end

  defp password_slice_position(password) do
    password |> String.length() |> rem(2)
  end

  @nostale_semver_regex ~r/(\d*)\.(\d*)\.(\d*)\.(\d*)/

  defp decode_client_vsn(v) do
    Regex.replace(@nostale_semver_regex, v, "\\1.\\2.\\3-\\4")
  end
end
