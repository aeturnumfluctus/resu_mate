defmodule ResuMate.MixProject do
  use Mix.Project

  @source_url "https://github.com/aeturnumfluctus/resu_mate"
  @version "0.1.0"

  def project do
    [
      app: :resu_mate,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [    
      licenses: ["Apache-2.0"],
      maintainers: ["Josh Adams"],
      links: %{"GitHub" => @source_url},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
