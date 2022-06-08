defmodule NoscoreTest do
  use ExUnit.Case, async: true
  import Mox
  import Noscore.PortalFixtures

  defmock(Noscore.MockTransport, for: Noscore.Transport)

  setup :verify_on_exit!

  setup do
    Noscore.MockTransport
    |> stub(:setopts, fn _, _ -> :ok end)
    |> stub(:send, fn _, _ -> :ok end)
    |> stub(:recv, fn _, _, _ -> {:ok, ""} end)

    {:ok, conn} = Noscore.Portal.initiate(Noscore.MockTransport, nil, scheme: :ns)

    {:ok, conn: conn}
  end

  test "stream nos0575 message", %{conn: conn} do
    data = nos0575_fixture()
    msg = nos0575_frame(data)

    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, IO.iodata_to_binary(msg)} end)

    assert {:ok, _, [{:frame, [:nos0575, username, _, _, _]}]} = Noscore.Portal.recv(conn)
    assert username === data.username
  end

  test "stream unknown event", %{conn: conn} do
    garbage = Faker.format("###############")
    expect(Noscore.MockTransport, :recv, fn _, _, _ -> {:ok, garbage} end)
    assert {:error, _, %Noscore.ParseError{}, []} = Noscore.Portal.recv(conn)
  end
end
