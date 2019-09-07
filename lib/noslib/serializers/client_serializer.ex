defmodule NosLib.ClientSerializer do
  @moduledoc """
  Client specific response serializer.
  """
  import NosLib.Packet
  alias NosLib.ErrorHelpers

  @type error :: %{reason: ErrorHelpers.reason()}
  @type info :: %{message: binary}

  @spec marshal(:error, error) :: [binary]
  def marshal(:error, param),
    do: [serialize_error(param)]

  @spec marshal(:info, info) :: [binary]
  def marshal(:info, param),
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
