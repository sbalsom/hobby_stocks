defmodule HobbyStocks.Supervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    children = [
      supervisor(HobbyStocks.Tiingo.Supervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
