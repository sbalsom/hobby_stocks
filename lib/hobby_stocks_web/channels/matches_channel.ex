defmodule HobbyStocksWeb.MatchesChannel do
  use Phoenix.Channel

  def join("matches:" <> symbol, _msg, socket) do
    IO.puts("joined matches channel for #{symbol}")
    {:ok, socket}
  end

  def terminate(reason, socket) do
    IO.puts("Closing socket #{inspect(socket.topic)} because #{inspect(reason)}")
  end
end
