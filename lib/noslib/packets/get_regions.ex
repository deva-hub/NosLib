defmodule Noslib.GetRegions do
  @moduledoc """
  GetRegions is the response to a Ping session_id.

  ```
  **GetRegions** `0x03` []

  Reply to peer's `Ping` packet.
  ```
  """

  alias Noslib.Server

  @type population :: non_neg_integer
  @type capacity :: non_neg_integer

  @type t :: %__MODULE__{
          session_id: non_neg_integer,
          servers: [Server.t()]
        }

  defstruct [:session_id, :servers]

  def deserialize([session_id, servers]) do
    %__MODULE__{
      session_id: session_id,
      servers: servers |> decode_enum(&(&1 |> decode_tuple |> Server.decode()))
    }
  end
end

defimpl Noslib.Encoder, for: Noslib.GetRegions do
  import Noslib.Helpers
  alias Noslib.Server

  def serialize(packet) do
    [
      "NsTeST",
      packet.session_id |> to_string(),
      packet.servers |> encode_enum(&(&1 |> Server.encode() |> encode_tuple))
    ]
  end
end
