defmodule HobbyStocks.StockPrice do
    use Ecto.Schema

    schema "stock_prices" do
      field :ticker, :string
      field :timestamp, :string
      field :last_sale_timestamp, :string
      field :quote_timestamp, :string
      field :open, :float
      field :prev_close, :float
      field :low, :float
      field :high, :float
      field :mid, :float
      field :last_size, :integer
      field :ask_price, :float
      field :ask_size, :float
      field :bid_price, :float
      field :bid_size, :float
      field :volume, :integer
      field :market_type, :string
    end

    def changeset(stock_price, params \\ %{}) do
      stock_price
      |> Ecto.Changeset.cast(params, [:ticker, :timestamp, :last_sale_timestamp, :quote_timestamp, :open, :prev_close, :low, :high, :mid, :last_size, :ask_price, :ask_size, :bid_price, :bid_size, :volume, :market_type])
      |> Ecto.Changeset.validate_required([:ticker, :timestamp])
    end
end
