defmodule NoscoreTest do
  use ExUnit.Case
  doctest Noscore

  test "stream nos0575 packet" do
    conn = %Noscore.Gateway{scheme: :ns}
    unknown_1 = Faker.format("????????????????")
    username = Faker.format("????????????????")
    password = "2EB6A196E4B60D96A9267E"
    unknown_2 = Faker.format("????????????????")
    version = Faker.App.version()
    command = Noscore.build("nos0575", [unknown_1, username, password, unknown_2, version])
    message = {:tcp, conn.socket, command}
    assert {:ok, _, res} = Noscore.Gateway.stream(conn, message)
    assert [{:command, ["nos0575", ^username, _, ^version]}] = res
  end

  test "stream unknown packet" do
    conn = %Noscore.Gateway{scheme: :ns}
    garbage = Faker.format("###############")
    message = {:tcp, conn.socket, garbage}
    assert {:data, ^garbage} = Noscore.Gateway.stream(conn, message)
  end
end
