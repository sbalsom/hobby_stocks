defmodule HobbyStocks.Tiingo.Api do
    @moduledoc """
    tiingo.com API wrapper
    """

    use Tesla

    @auth %{token: Application.get_env(:hobby_stocks, :tiingo_token)}

    plug Tesla.Middleware.BaseUrl, "https://api.tiingo.com/iex"
    plug Tesla.Middleware.JSON

    def poll(%{ticker: ticker}) do
      ticker = String.upcase(ticker)

      case get(ticker, query: @auth) do
        {:ok, %Tesla.Env{body: [%{"ticker"=> ^ticker}]} = response} ->
          IO.write("success!")
          IO.inspect(response.body)
          # TODO : save data to DB
        {:ok, %Tesla.Env{body: %{"detail" => "Please supply a token"}} = response} ->
          IO.write("error no token!")
          IO.inspect(response)
          # TODO : log response, request data, and error
        error ->
          IO.write("unknown error:(")
          IO.inspect(error)
          # TODO : log error
      end
    end
end
