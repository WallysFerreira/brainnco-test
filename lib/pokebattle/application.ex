defmodule Pokebattle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PokebattleWeb.Telemetry,
      Pokebattle.Repo,
      {DNSCluster, query: Application.get_env(:pokebattle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pokebattle.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pokebattle.Finch},
      # Start a worker by calling: Pokebattle.Worker.start_link(arg)
      # {Pokebattle.Worker, arg},
      # Start to serve requests, typically the last entry
      PokebattleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pokebattle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PokebattleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
