defmodule HobbyStocksWeb.StocksController do
  use HobbyStocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"ticker" => ticker}) do
    # use params[:ticker] to display one single stock profile
    render(conn, "show.html", ticker: ticker)
  end
end
