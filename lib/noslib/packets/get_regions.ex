defmodule NosLib.GetRegions do
  @moduledoc """
  GetRegions is the server list sent by the portal.
  """
  import NosLib.Helpers
  alias NosLib.Server

  @type t :: %__MODULE__{
          session_id: non_neg_integer,
          servers: [Server.t()]
        }

  defstruct session_id: 0,
            servers: []

  def deserialize([session_id, servers]) do
    %__MODULE__{
      session_id: session_id,
      servers: servers |> decode_enum(&(&1 |> decode_tuple() |> Server.decode()))
    }
  end
end

defimpl NosLib.Encoder, for: NosLib.GetRegions do
  import NosLib.Helpers
  alias NosLib.Server

  def serialize(packet) do
    [
      "NsTeST",
      packet.session_id |> to_string(),
      packet.servers |> encode_enum(&(&1 |> Server.encode() |> encode_tuple))
    ]
  end
end
