defmodule NosLib.ErrorHelpers do
  @moduledoc """
  Helpers for error serialization.
  """

  @type reason ::
          :outdated_client
          | :unexpected_error
          | :maintenance
          | :session_already_used
          | :unvalid_credentials
          | :cant_authenticate
          | :citizen_blacklisted
          | :country_blacklisted
          | :bad_case

  @spec encode_reason(reason) :: iodata
  def encode_reason(:outdated_client), do: "1"
  def encode_reason(:unexpected_error), do: "2"
  def encode_reason(:maintenance), do: "3"
  def encode_reason(:session_already_used), do: "4"
  def encode_reason(:unvalid_credentials), do: "5"
  def encode_reason(:cant_authenticate), do: "6"
  def encode_reason(:citizen_blacklisted), do: "7"
  def encode_reason(:country_blacklisted), do: "8"
  def encode_reason(:bad_case), do: "9"
end
