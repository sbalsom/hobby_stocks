defmodule HobbyStocksWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "ticker:*", HobbyStocksWeb.TickerChannel
  channel "match:*", HobbyStocksWeb.MatchChannel

  @impl false
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
