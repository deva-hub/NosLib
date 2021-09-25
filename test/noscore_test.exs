defmodule NoscoreTest do
  use ExUnit.Case, async: true
  import Mox
  import Noscore.Event.Helpers
  import Noscore.GatewayFixtures

  defmock(Noscore.MockTransport, for: Noscore.Transport)

  setup :verify_on_exit!

  setup do
    conn = %Noscore.Gateway{
      scheme: :ns,
      transport: Noscore.MockTransport
    }

    {:ok, conn: conn}
  end

  test "stream nos0575 packet", %{conn: conn} do
    data = nos0575_fixture()

    command =
      data
      |> nos0575_packet()
      |> Noscore.Event.to_string()

    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, command} end)

    assert {:ok, _, [{:command, ["nos0575", username, _, _]}]} = Noscore.Gateway.recv(conn)
    assert username === data.username
  end

  test "stream unknown packet", %{conn: conn} do
    garbage = Faker.format("###############")
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, garbage} end)
    assert {:error, _, %Noscore.ParseError{}, []} = Noscore.Gateway.recv(conn)
  end

  def nos0575_packet(packet) do
    nslist([
      "nos0575",
      Faker.format("????????????????"),
      packet.username,
      packet.password,
      Faker.format("????????????????"),
      packet.version
    ])
  end
end
