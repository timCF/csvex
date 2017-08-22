defmodule Csvex.Mixfile do
  use Mix.Project

  def project do
    [app: :csvex,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :csv],
     mod: {Csvex, []}]
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
    [
    	{:csv, github: "beatrichartz/csv", tag: "36b048ef4103ab5be0e39669cd627f34cd5543d1", override: true},
    ]
  end
end
