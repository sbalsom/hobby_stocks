defmodule HobbyStocksWeb.PageController do
  use HobbyStocksWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
