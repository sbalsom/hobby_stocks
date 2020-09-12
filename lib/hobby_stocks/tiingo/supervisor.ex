defmodule HobbyStocks.Tiingo.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    # TODO : Could supervise many workers who make different types of API calls
    children = [
      worker(HobbyStocks.Tiingo.PollClient, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
