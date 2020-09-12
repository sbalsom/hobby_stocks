defmodule HobbyStocks.Repo.Migrations.CreateStockPrices do
  use Ecto.Migration

  def change do
    create table(:stock_prices) do
      add :ticker, :string, null: false
      add :timestamp, :string, null: false
      add :last_sale_timestamp, :string
      add :quote_timestamp, :string
      add :open, :float
      add :prev_close, :float
      add :low, :float
      add :high, :float
      add :mid, :float
      add :last_size, :integer
      add :ask_price, :float
      add :ask_size, :float
      add :bid_price, :float
      add :bid_size, :float
      add :volume, :integer
      add :market_type, :string
    end
  end
end
