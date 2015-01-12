defmodule Ashes.Mixfile do
  use Mix.Project

  def project do
    [app: :ashes,
     version: "0.0.1",
     elixir: "~> 1.0",
     description: "A code generation tool for the phoenix web framework",
     source_url: "https://github.com/nickgartmann/ashes",
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [] end

  defp package do
    [
      files: ["lib", "templates", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Nick Gartmann"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/nickgartmann/ashes"}
    ]
  end
end
