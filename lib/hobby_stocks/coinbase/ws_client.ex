defmodule HobbyStocks.Coinbase.WSClient do
  @moduledoc """
  Connects to the Coinbase websockets stream on app startup

  FYI data for match channel will look like this  :
  %{
    "maker_order_id" => "048f76da-a87d-40b5-b069-dfaee4f0f420",
    "price" => "10927.98",
    "product_id" => "BTC-USD",
    "sequence" => 16369068279,
    "side" => "buy",
    "size" => "0.009151",
    "taker_order_id" => "2ca9bf29-5e0e-4734-9530-caac147e519f",
    "time" => "2020-09-17T19:46:11.663167Z",
    "trade_id" => 103643682,
    "type" => "match"
  }

  data for ticker channel will look like this :

  %{
  "best_ask" => "10960.54",
  "best_bid" => "10960.53",
  "high_24h" => "11179.9",
  "last_size" => "0.00472167",
  "low_24h" => "10902.33",
  "open_24h" => "10993",
  "price" => "10960.54",
  "product_id" => "BTC-USD",
  "sequence" => 16409604217,
  "side" => "buy",
  "time" => "2020-09-20T10:40:23.932992Z",
  "trade_id" => 103849921,
  "type" => "ticker",
  "volume_24h" => "6321.61958225",
  "volume_30d" => "345117.44937645"
  }

  """
  use WebSockex

  @url "wss://ws-feed.pro.coinbase.com"

  def start_link(opts \\ []) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, opts)
    subscribe(pid, opts)
    {:ok, pid, opts}
  end

  def handle_connect(_conn, state) do
    IO.puts("Connected ! ")
    {:ok, state}
  end

  def subscribe(pid, %{products: products, channels: channels}) do
    IO.puts("Subscribing...")
    WebSockex.send_frame(pid, subscription_frame(products, channels))
  end

  def subscription_frame(products, channels) do
    IO.inspect(channels)

    subscription_msg =
      %{
        type: "subscribe",
        product_ids: products,
        channels: channels
      }
      |> Jason.encode!()

    {:text, subscription_msg}
  end

  def handle_frame({:text, msg}, state) do
    handle_msg(Jason.decode!(msg), state)
    {:ok, state}
  end

  defp handle_msg(%{"type" => channel, "product_id" => symbol} = trade, state) do
    IO.write("yay")
    # IO.inspect(trade)
    channel_name = "#{channel}:#{symbol}"
    IO.puts(channel_name)
    HobbyStocksWeb.Endpoint.broadcast(channel_name, "#{channel}_event", trade)
    {:ok, state}
  end

  defp handle_msg(any, state) do
    IO.write("whoops")
    IO.inspect(any)
    {:ok, state}
  end

  def handle_disconnect(_conn, state) do
    IO.puts("Disconnected :(")
    {:reconnect, state}
  end
end
