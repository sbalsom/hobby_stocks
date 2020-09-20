defmodule HobbyStocksWeb.MatchChannel do
  use Phoenix.Channel

  def join("match:" <> symbol, _msg, socket) do
    IO.puts("joined match channel for #{symbol}")
    {:ok, socket}
  end

  def terminate(reason, socket) do
    IO.puts("Closing socket #{inspect(socket.topic)} because #{inspect(reason)}")
  end
end
