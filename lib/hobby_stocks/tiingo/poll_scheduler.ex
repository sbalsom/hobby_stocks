defmodule HobbyStocks.Tiingo.PollScheduler do
  @moduledoc """
  Schedules hourly polls of apple stock data from tiingo on startup
  """
  use GenServer

  alias HobbyStocks.Tiingo.ApiClient

  def start_link do
    # Hard coded to fetch only Apple Stocks
    GenServer.start_link(__MODULE__, %{ticker: "aapl"}, name: __MODULE__)
  end

  def init(initial_data) do
    schedule_self()
    {:ok, initial_data}
  end

  def poll do
    GenServer.cast(__MODULE__, :poll_tiingo)
  end

  def handle_cast(:poll_tiingo, state) do
    ApiClient.poll(state)
    {:noreply, state}
  end

  def handle_info(:schedule_work, state) do
    poll()
    schedule_self()
    {:noreply, state}
  end

  defp schedule_self() do
    # Calls Api Client once an hour to fetch stock data (to test, change value to 5000)
    Process.send_after(self(), :schedule_work, 60 * 60 * 1000)
  end
end
