defmodule HobbyStocks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HobbyStocks.Repo,
      # Start the Telemetry supervisor
      HobbyStocksWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HobbyStocks.PubSub},
      # Start the Endpoint (http/https)
      HobbyStocksWeb.Endpoint,
      # Start Supervision Tree
      {Cachex, name: :coinbase_cache, limit: 12000},
      HobbyStocks.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HobbyStocks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HobbyStocksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
