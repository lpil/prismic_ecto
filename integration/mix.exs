defmodule Integration.Mixfile do
  use Mix.Project

  def project do
    [app: :integration,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps_path: "../../deps",
     deps: deps()]
  end

  def application do
    [applications: [:logger],
     mod: {Integration, []}]
  end

  defp deps do
    [{:prismic_ecto, path: "../"}]
  end
end
