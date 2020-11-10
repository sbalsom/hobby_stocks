defmodule HobbyStocksWeb.StocksController do
  use HobbyStocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def stream(conn, %{"ticker" => ticker, "channel" => channel}) do
    render(conn, "stream.html", ticker: ticker, channel: channel)
  end
end
