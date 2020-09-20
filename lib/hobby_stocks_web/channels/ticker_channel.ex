defmodule HobbyStocksWeb.TickerChannel do
  use Phoenix.Channel

  def join("ticker:" <> symbol, _msg, socket) do
    IO.puts("joined ticker channel for #{symbol}")
    {:ok, socket}
  end

  def terminate(reason, socket) do
    IO.puts("Closing socket #{inspect(socket.topic)} because #{inspect(reason)}")
  end
end
