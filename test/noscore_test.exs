defmodule NoscoreTest do
  use ExUnit.Case
  doctest Noscore

  test "stream nos0575 packet" do
    conn = Noscore.Login.new()
    unknown_1 = Faker.format("????????????????")
    username = Faker.format("????????????????")
    password = Faker.format("????????????????")
    unknown_2 = Faker.format("????????????????")
    version = Faker.App.version()
    unknown_3 = Faker.format("????????????????")
    checksum = Faker.format("###############")

    command =
      Noscore.build("nos0575", [
        unknown_1,
        username,
        password,
        unknown_2,
        version,
        unknown_3,
        checksum
      ])

    message = {:tcp, conn.socket, command}

    assert {:ok, _, [{:command, ["nos0575", ^username, ^password, ^version, ^checksum]}]} =
             Noscore.Login.stream(conn, message)
  end

  test "stream unknown packet" do
    conn = Noscore.Login.new()
    garbage = Faker.format("###############")
    message = {:tcp, conn.socket, garbage}
    assert :unknown = Noscore.Login.stream(conn, message)
  end
end
