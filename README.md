# HobbyStocks

A hobby app that intends to fetch (Apple) stock prices from Tiingo.com api and save them to a database for later analysis.

ENV variables to add to `.env` file:

'PGPORT' is a configurable ENV variable in order to use the project database on a port other than the default PostGres port

'TIINGO_TOKEN': In order for the API calls to work, you must have a working Tiingo API token, and it must be saved as an ENV variable

Token can be created here for free : https://api.tiingo.com/

some known issues come up with reading these env variables (for unknown to me reasons), so you may need to run `TIINGO_TOKEN=<YOUR TOKEN> iex -S mix` for it to actually work

To start Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

As soon as the server is started with either `mix phx.server` or `iex -S mix`, the stock data will begin fetching and saving. Requests run once an hour.
Starting the server also boots up the websockets client, which streams data from Coinbase for 4 different cryptocurrency products ("BTC-USD, "BTC-EUR", "ETH-USD', "ETH-EUR"). Navigating to the show page of each of these stocks will take you to a livestream of that stocks prices.

The endpoints are as follows :
Index all stocks (WIP) :
`http://localhost:4000/stocks`

Show for one stock (static - WIP):
`http://localhost:4000/stocks/<SYMBOL>`

Stream for one stock:
`http://localhost:4000/livestocks/stream?ticker=<SYMBOL>&channel=<CHANNEL_TYPE>`
where SYMBOL = one of the cryptocurrency product symbols, and CHANNEL_TYPE can be one of "ticker" or "match"

![Screenshot 2020-09-20 at 21 34 08](https://user-images.githubusercontent.com/46577238/93720553-171c2300-fb8a-11ea-9942-859d6363dbb3.png)
