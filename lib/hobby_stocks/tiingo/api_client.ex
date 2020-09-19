defmodule HobbyStocks.Tiingo.ApiClient do
  @moduledoc """
  tiingo.com API wrapper
  """

  use Tesla

  alias HobbyStocks.Tiingo.StockStorage

  @auth %{token: Application.get_env(:hobby_stocks, :tiingo_token)}

  plug Tesla.Middleware.BaseUrl, "https://api.tiingo.com/iex"
  plug Tesla.Middleware.JSON

  def poll(%{ticker: ticker}) do
    ticker = String.upcase(ticker)

    case get(ticker, query: @auth) do
      {:ok, %Tesla.Env{body: [%{"ticker" => ^ticker} = data]} = _response} ->
        StockStorage.save(data)

      {:ok, %Tesla.Env{body: %{"detail" => "Please supply a token"}} = _response} ->
        IO.puts("error no token!")

      # TODO : log response, request data, and error
      error ->
        IO.puts("unknown error:(")
        IO.inspect(error)
        # TODO : log errors
    end
  end
end
