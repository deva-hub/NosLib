defmodule Noscore.Parser do
  alias Noscore.Parser.{Portal, Gateway}
  import NimbleParsec

  defparsec(:portal_command, Portal.event())
  defparsec(:gateway_session, Gateway.key())
  defparsec(:gateway_auth, Gateway.auth())
  defparsec(:gateway_command, Gateway.event())
end
