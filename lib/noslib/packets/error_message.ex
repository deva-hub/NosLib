defmodule Noslib.ErrorMessage do
  @moduledoc """
  ErrorMessage is the response to a Ping reason.

  ```
  **ErrorMessage** `0x03` []

  Reply to peer's `Ping` packet.
  ```
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

  @type t :: %__MODULE__{reason: reason}

  defstruct [:reason]

  def deserialize([reason]) do
    %__MODULE__{reason: reason}
  end
end

defimpl Noslib.Encoder, for: Noslib.ErrorMessage do
  def serialize(packet) do
    ["failc", packet.reason |> encode_reason()]
  end

  defp encode_reason(:outdated_client), do: "1"
  defp encode_reason(:unexpected_error), do: "2"
  defp encode_reason(:maintenance), do: "3"
  defp encode_reason(:session_already_used), do: "4"
  defp encode_reason(:unvalid_credentials), do: "5"
  defp encode_reason(:cant_authenticate), do: "6"
  defp encode_reason(:citizen_blacklisted), do: "7"
  defp encode_reason(:country_blacklisted), do: "8"
  defp encode_reason(:bad_case), do: "9"
end
