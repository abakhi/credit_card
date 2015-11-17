defmodule CreditCard.Mixfile do
  use Mix.Project

  def project do
    [app: :credit_card,
     version: "0.0.1",
     description: "A library for validating credit card numbers",
     source_url: "https://github.com/abakhi/credit_card",
     package: package,
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
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
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:earmark, "~> 0.1", only: :docs},
     {:ex_doc, "~> 0.10", only: :docs},
     {:inch_ex, "~> 0.2", only: :docs},]
  end

  defp package do
    [
      maintainers: ["Mawuli Adzaku", "Kirk S. Agbenyegah"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/abakhi/credit_card",
        "Documentation" => "http://hexdocs.pm/credit_card"
      }
    ]
  end
end
