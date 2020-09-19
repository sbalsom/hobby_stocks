defmodule HobbyStocks.Coinbase.WSClient do
  @moduledoc """
  Connects to the Coinbase websockets stream on app startup

  # FYI when it comes in data will look like this :
  # %{
  #   "maker_order_id" => "048f76da-a87d-40b5-b069-dfaee4f0f420",
  #   "price" => "10927.98",
  #   "product_id" => "BTC-USD",
  #   "sequence" => 16369068279,
  #   "side" => "buy",
  #   "size" => "0.009151",
  #   "taker_order_id" => "2ca9bf29-5e0e-4734-9530-caac147e519f",
  #   "time" => "2020-09-17T19:46:11.663167Z",
  #   "trade_id" => 103643682,
  #   "type" => "match"
  # }

  """
  use WebSockex

  @url "wss://ws-feed.pro.coinbase.com"

  def start_link(products \\ []) do
    IO.inspect(products)
    WebSockex.start_link(@url, __MODULE__, products)
  end

  def handle_connect(_conn, state) do
    IO.puts("Connected!")
    {:ok, state}
  end

  def subscribe(pid, products) do
    IO.puts("subscribing...")
    WebSockex.send_frame(pid, subscription_frame(products))
  end

  def subscription_frame(products) do
    subscription_msg =
      %{
        type: "subscribe",
        product_ids: products,
        channels: ["matches"]
      }
      |> Jason.encode!()

    {:text, subscription_msg}
  end

  def handle_frame({:text, msg}, state) do
    IO.inspect(state)
    IO.puts("handling frame ...")
    handle_msg(Jason.decode!(msg), state)
    {:ok, state}
  end

  defp handle_msg(%{"type" => "match"} = trade, state) do
    IO.puts("handling msg...")
    IO.inspect(trade)
    # TODO : this should be received by frontend and displayed to user
    # HobbyStocksWeb.Endpoint.broadcast("ticker:#{inspect(state)}", trade)
    {:ok, state}
  end

  defp handle_msg(_, state), do: {:ok, state}

  def handle_disconnect(_conn, state) do
    IO.puts("disconnected")
    {:reconnect, state}
  end
end
