defmodule Noscore.Parser do
  alias Noscore.Parser.{Portal, Gateway}
  import NimbleParsec

  defparsec(:portal_body, Portal.request())
  defparsec(:gateway_session, Gateway.key())
  defparsec(:gateway_auth, Gateway.auth())
  defparsec(:gateway_body, Gateway.request())
end
