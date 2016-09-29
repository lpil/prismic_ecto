defmodule Prism.Mixfile do
  use Mix.Project

  def project do
    [app: :prism,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :poison]]
  end

  defp deps do
    [
      # JSON parser
      {:poison, "~> 2.2"},

      # Style linter
      {:dogma, ">= 0.0.0", only: [:dev, :test]},
      # Automatic test runner
      {:mix_test_watch, ">= 0.0.0", only: :dev},
    ]
  end
end
