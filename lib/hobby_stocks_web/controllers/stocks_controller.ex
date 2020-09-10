defmodule HobbyStocksWeb.StocksController do
  use HobbyStocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
