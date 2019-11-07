defmodule ColourHash.MixProject do
  use Mix.Project

  def project do
    [
      app: :colour_hash,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A package to hash a string into a colour to be used as a personified colour or simular.",
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    []
  end

  defp package do
    [
      name: "colour_hash",
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/zesarone/colour_hash"}
    ]
  end
end
