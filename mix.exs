defmodule NosLib.MixProject do
  @moduledoc false
  use Mix.Project

  @version "0.2.0"
  @repo_url "https://github.com/deva-hub/NosLib"

  def project do
    [
      app: :noslib,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "NosTale protocol parsing library.",
      package: package(),
      name: "NosLib",
      docs: docs()
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: :dev, runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: @repo_url
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Shikanime Deva"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url}
    ]
  end
end
