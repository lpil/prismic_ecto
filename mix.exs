defmodule Prismic.Ecto.Mixfile do
  use Mix.Project

  def project do
    [app: :prismic_ecto,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     deps_path: "../deps"]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      # Datastore querying DSL
      {:ecto, "~> 2.0"},
      # JSON parser
      {:poison, "~> 2.2"},

      # Style linter
      {:dogma, ">= 0.0.0", only: [:dev, :test]},
      # Automatic test runner
      {:mix_test_watch, ">= 0.0.0", only: :dev},
    ]
  end
end
