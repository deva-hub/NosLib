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

  test "stream nos0575 event", %{conn: conn} do
    data = nos0575_fixture()

    event =
      data
      |> nos0575_event()
      |> Noscore.Event.to_string()

    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, event} end)

    assert {:ok, _, [{:event, ["nos0575", username, _, _]}]} = Noscore.Gateway.recv(conn)
    assert username === data.username
  end

  test "stream unknown event", %{conn: conn} do
    garbage = Faker.format("###############")
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, garbage} end)
    assert {:error, _, %Noscore.ParseError{}, []} = Noscore.Gateway.recv(conn)
  end

  def nos0575_event(event) do
    nslist([
      "nos0575",
      Faker.format("????????????????"),
      event.username,
      event.password,
      Faker.format("????????????????"),
      event.version
    ])
  end
end
