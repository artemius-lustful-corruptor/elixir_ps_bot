defmodule ProletarianSolidarity.MixProject do
  use Mix.Project

  def project do
    [
      app: :proletarian_solidarity,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env),
      applications: [:ex_machina]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ProletarianSolidarity.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:telegram, git: "https://github.com/visciang/telegram.git", tag: "0.8.0"},
      {:distillery, "~> 2.0"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:mox, ">= 0.0.0"}
    ]
  end
end
