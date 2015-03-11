defmodule PlugRedisSession.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_redis_session,
     version: "0.0.1",
     elixir: "~> 1.0",
     package: package,
     description: description,
     deps: deps]
  end

  def application do
    [applications: [:logger, :poison],
     mod: {PlugRedisSession, []}]
  end

  defp deps do
    [
      { :cowboy, "~> 1.0.0" },
      { :plug, "~> 0.10.0" },
      { :poison, "~> 1.3.1" },
      { :exredis_pool, github: "teodor-pripoae/exredis_pool" },
      { :amrita, "~> 0.4", github: "josephwilk/amrita", only: :test }
    ]
  end

  defp description do
    """
    Redis store support for plug sessions.
    """
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Teodor Pripoae"],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/teodor-pripoae/plug_redis_session"
      }
    ]
  end
end
