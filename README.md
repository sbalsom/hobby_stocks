# HobbyStocks

A hobby app that intends to fetch (Apple) stock prices from Tiingo.com api and save them to a database for later analysis.

ENV variables to add to `.env` file:

'PGPORT' is a configurable ENV variable in order to use the project database on a port other than the defualt PostGres port
'TIINGO_TOKEN': In order for the API calls to work, you must have a working Tiingo API token, and it must be saved as an ENV variable

some known issues come up with reading these env variables (for unknown to me reasons), so you may need to run `TIINGO_TOKEN=<YOUR TOKEN> iex -S mix` for it to actually work
To start Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

As soon as the server is started with either `mix phx.server` or `iex -S mix`, the stock data will begin fetching and saving. Requests run once an hour.

Only two endpoints exist on the user interface : An index and a show page. Neither of them are currently used, but in the future could be used to display available stocks on Tiingo API, and possibly allow the user to select a specific stock they would like to have saved, and save it to a CSV file for data analysis.

