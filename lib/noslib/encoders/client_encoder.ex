defmodule NosLib.ClientEncoder do
  @moduledoc """
  Client specific response.
  """
  alias NosLib.ErrorHelpers

  @type error :: %{reason: ErrorHelpers.reason()}
  @type info :: %{message: bitstring}

  @spec encode(:error, error) :: [binary]
  def encode(:error, param),
    do: [IO.iodata_to_binary(decode_error(param))]

  @spec encode(:info, info) :: [binary]
  def encode(:info, param),
    do: [IO.iodata_to_binary(decode_info(param))]

  @spec encode_to_iodata(:error, error) :: [iodata]
  def encode_to_iodata(:error, param),
    do: [decode_error(param)]

  @spec encode_to_iodata(:info, info) :: [iodata]
  def encode_to_iodata(:info, param),
    do: [decode_info(param)]

  def decode_error(param) do
    [
      "failc",
      " ",
      ErrorHelpers.encode_reason(param.reason)
    ]
  end

  def decode_info(param) do
    [
      "info",
      " ",
      param.message
    ]
  end
end
