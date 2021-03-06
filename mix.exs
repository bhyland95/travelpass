defmodule Travelpass.MixProject do
  use Mix.Project

  def project do
    [
      app: :travelpass,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"}, 
      {:poison, "~> 5.0"}, 
      {:mox, "~> 1.0", only: :test},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
