defmodule NosLib.ErrorHelpers do
  @moduledoc """
  Helpers for error serialization.
  """

  @type reason ::
          :unsupported_client
          | :unexpected_error
          | :maintenance
          | :session_already_used
          | :unvalid_credentials
          | :cant_authenticate
          | :citizen_blacklisted
          | :country_blacklisted
          | :bad_case

  @spec serialize_reason(reason) :: non_neg_integer
  def serialize_reason(:unsupported_client), do: 1
  def serialize_reason(:unexpected_error), do: 2
  def serialize_reason(:maintenance), do: 3
  def serialize_reason(:session_already_used), do: 4
  def serialize_reason(:unvalid_credentials), do: 5
  def serialize_reason(:cant_authenticate), do: 6
  def serialize_reason(:citizen_blacklisted), do: 7
  def serialize_reason(:country_blacklisted), do: 8
  def serialize_reason(:bad_case), do: 9
end
