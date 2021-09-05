defmodule NoscoreTest do
  use ExUnit.Case, async: true
  import Mox

  defmock(Noscore.MockTransport, for: Noscore.Transport)

  setup :verify_on_exit!

  test "stream nos0575 packet" do
    conn = %Noscore.Gateway{scheme: :ns, transport: Noscore.MockTransport}
    unknown_1 = Faker.format("????????????????")
    username = Faker.format("????????????????")
    password = "2EB6A196E4B60D96A9267E"
    unknown_2 = Faker.format("????????????????")
    version = Faker.App.version()
    command = Noscore.build("nos0575", [unknown_1, username, password, unknown_2, version])
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, command} end)
    assert {:ok, ["nos0575", ^username, _, ^version]} = Noscore.Gateway.recv(conn)
  end

  test "stream unknown packet" do
    conn = %Noscore.Gateway{scheme: :ns, transport: Noscore.MockTransport}
    garbage = Faker.format("###############")
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, garbage} end)
    assert {:error, %Noscore.ParseError{}} = Noscore.Gateway.recv(conn)
  end
end
