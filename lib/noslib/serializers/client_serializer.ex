defmodule NosLib.ClientSerializer do
  @moduledoc """
  Client specific response serializer.
  """
  import NosLib.Packet
  alias NosLib.ErrorHelpers

  @type error :: %{reason: ErrorHelpers.reason()}

  @type info :: %{message: binary}

  def render(template, param)

  @spec render(:error, error) :: [binary]
  def render(:error, param),
    do: [serialize_error(param)]

  @spec render(:info, info) :: [binary]
  def render(:info, param),
    do: [serialize_info(param)]

  def serialize_error(param) do
    assemble([
      "failc",
      ErrorHelpers.serialize_reason(param.reason)
    ])
  end

  def serialize_info(param) do
    assemble([
      "info",
      param.message
    ])
  end
end
