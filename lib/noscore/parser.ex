defmodule Noscore.Parser do
  alias Noscore.Parser.{Gateway, Portal}
  import NimbleParsec

  defparsec(:gateway_command, Gateway.event())
  defparsec(:portal_session, Portal.key())
  defparsec(:portal_auth, Portal.auth())
  defparsec(:portal_command, Portal.event())
end
