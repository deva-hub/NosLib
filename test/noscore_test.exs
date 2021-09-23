defmodule NoscoreTest do
  use ExUnit.Case, async: true
  import Mox
  import Noscore.Event.Helpers

  defmock(Noscore.MockTransport, for: Noscore.Transport)

  setup :verify_on_exit!

  test "stream nos0575 packet" do
    conn = %Noscore.Gateway{scheme: :ns, transport: Noscore.MockTransport}

    data = %{
      username: Faker.format("????????????????"),
      password: "2EB6A196E4B60D96A9267E",
      version: "1.2.3.4"
    }

    command =
      data
      |> nos0575_packet()
      |> Noscore.Event.to_string()

    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, command} end)

    assert {:ok, ["nos0575", username, _, "1.2.3+4"]} = Noscore.Gateway.recv(conn)
    assert username === data.username
  end

  test "stream unknown packet" do
    conn = %Noscore.Gateway{scheme: :ns, transport: Noscore.MockTransport}
    garbage = Faker.format("###############")
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, garbage} end)
    assert {:error, %Noscore.ParseError{}} = Noscore.Gateway.recv(conn)
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
