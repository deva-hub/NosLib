defmodule NosLib.ClientSerializer do
  @moduledoc """
  Response relateh to client
  """
  import NosLib.Packet
  alias NosLib.ErrorSerializer

  @type error :: %{
          reason: ErrorSerializer.reason()
        }

  @type info :: %{
          message: String.t()
        }

  @spec render(:error, error) :: [String.t()]
  def render(:error, param) do
    [serialize_error(param)]
  end

  @spec render(:info, info) :: [String.t()]
  def render(:info, param) do
    [serialize_info(param)]
  end

  @spec serialize_info(error) :: String.t()
  def serialize_error(param) do
    assemble([
      "failc",
      ErrorSerializer.serialize_reason(param.reason)
    ])
  end

  @spec serialize_info(info) :: String.t()
  def serialize_info(param) do
    assemble([
      "info",
      param.message
    ])
  end
end
