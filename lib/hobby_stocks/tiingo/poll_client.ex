defmodule HobbyStocks.Tiingo.PollClient do
  use GenServer

  alias HobbyStocks.Tiingo.Api

  def start_link do
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
    Api.poll(state)
    {:noreply, state}
  end

  def handle_info(:schedule_work, state) do
    poll()
    schedule_self()
    {:noreply, state}
  end

  defp schedule_self() do
    # TODO : only schedule work if the stock market is open ?
    # TODO : Instead of calling this endpoint once an hour, call the historical prices endpoint with freq = 5 minutes
    # and save all the data from that one call to db
    #  TODO : Could use QUantum Core cron scheduler instead
    Process.send_after(self(), :schedule_work, 60 * 60 * 1000)
  end

end
