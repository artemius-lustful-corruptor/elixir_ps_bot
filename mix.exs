defmodule App.Mixfile do
  use Mix.Project

  def project do
    [app: :app,
     version: "0.1.0",
     elixir: "~> 1.3",
     default_task: "server",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     aliases: aliases()]
  end

  def application do
    [applications: [:logger, :nadia],
     mod: {App, []}]
  end

  defp deps do
    [
      {:nadia, "~> 0.6.0"},
      {:poison, "~> 3.1"},
      {:redix, ">= 0.0.0"},
      {:gettext, "~> 0.13"},
      {:distillery, "~> 2.1"}
    ]
  end

  defp aliases do
    [server: "run --no-halt"]
  end
end
