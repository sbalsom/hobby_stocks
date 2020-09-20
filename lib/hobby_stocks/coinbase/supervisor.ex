defmodule HobbyStocks.Coinbase.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      worker(
        HobbyStocks.Coinbase.WSClient,
        [
          %{
            products: ["BTC-USD", "BTC-EUR", "ETH-USD", "ETH-EUR"],
            channels: ["ticker", "matches"]
          }
        ],
        id: :coinbase_crypto_worker
      )
    ]

    supervise(children, strategy: :one_for_one)
  end
end
