defmodule HobbyStocks.Tiingo.PollClient do
  use GenServer

  alias HobbyStocks.Tiingo.PollClient
  alias HobbyStocks.Tiingo.Api

  # client side

  def start_link do
    GenServer.start_link(__MODULE__, %{ticker: "aapl"}, name: __MODULE__)
  end

  def init(initial_data) do
    IO.inspect(initial_data)
    # state = %{client: []}
    {:ok, initial_data}
  end

  def poll(_args) do
    GenServer.cast(__MODULE__, :poll_tiingo)
  end

  def handle_cast(:poll_tiingo, state) do
    Api.poll(state)
    {:noreply, state}
  end

end
