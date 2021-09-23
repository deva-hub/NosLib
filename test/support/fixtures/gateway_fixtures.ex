defmodule Noscore.GatewayFixtures do
  def nos0575_fixture do
    %{
      username: Faker.format("????????????????"),
      password: "2EB6A196E4B60D96A9267E",
      version: Faker.format("#.#.#.#")
    }
  end
end
