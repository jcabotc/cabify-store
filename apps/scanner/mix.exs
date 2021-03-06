defmodule Scanner.Mixfile do
  use Mix.Project

  def project do
    [app: :scanner,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Scanner.Application, []}]
  end

  defp deps do
    [{:purchase, in_umbrella: true}]
  end
end
