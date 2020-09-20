defmodule HobbyStocks.Coinbase.CacheLoader do
  @moduledoc """
  Loads 200 cached stock prices on demand of streaming webpage
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info({:load_cache, symbol}, state) do
    load_cache(symbol)
    {:noreply, state}
  end

  defp load_cache(symbol) do
    fun = fn x ->
      {:entry, _, _, _, value} = x
      value
    end

    query = Cachex.Query.unexpired()

    cache =
      :coinbase_cache
      |> Cachex.stream!(query)
      |> Enum.to_list()
      |> Enum.map(fun)
      |> Enum.filter(fn x -> x["product_id"] == symbol end)
      |> Enum.sort(&compare_dates(date_from_string(&1["time"]), date_from_string(&2["time"])))
      |> Enum.take(200)

    cache_msg = %{cache: cache}
    HobbyStocksWeb.Endpoint.broadcast("ticker:" <> symbol, "cache_load", cache_msg)
  end

  def date_from_string(string) do
    {:ok, date, _} = DateTime.from_iso8601(string)
    date
  end

  def compare_dates(d1, d2) do
    case DateTime.compare(d1, d2) do
      :gt -> true
      _ -> false
    end
  end
end
