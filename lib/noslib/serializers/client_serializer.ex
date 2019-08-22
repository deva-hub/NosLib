defmodule NosLib.ClientSerializer do
  @moduledoc """
  Response relateh to client
  """
  import NosLib.SerializerUtil

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

  @type error :: %{
          reason: reason
        }

  @type info :: %{
          message: String.t()
        }

  @spec render(:error, error) :: [String.t()]
  def render(:error, param) do
    [serialize_params(["failc", serialize_error(param.reason)])]
  end

  @spec render(:info, info) :: [String.t()]
  def render(:info, param) do
    [serialize_params(["info", param.message])]
  end

  defp serialize_error(:outdated_client), do: 1
  defp serialize_error(:unexpected_error), do: 2
  defp serialize_error(:maintenance), do: 3
  defp serialize_error(:session_already_used), do: 4
  defp serialize_error(:unvalid_credentials), do: 5
  defp serialize_error(:cant_authenticate), do: 6
  defp serialize_error(:citizen_blacklisted), do: 7
  defp serialize_error(:country_blacklisted), do: 8
  defp serialize_error(:bad_case), do: 9
end
