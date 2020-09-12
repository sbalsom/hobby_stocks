defmodule HobbyStocks.Tiingo.StockStorage do

    alias HobbyStocks.StockPrice
    alias HobbyStocks.Repo

    def save(stock_data) do
      # TODO : Log saving data to db
      stock_price = %StockPrice{}
      attrs = adapt(stock_data)
      changeset = StockPrice.changeset(stock_price, attrs)
      case Repo.insert(changeset) do
        {:ok, _stock_price} -> IO.write("Stock saved ! ")
        {:error, changeset} -> IO.inspect(changeset.errors)
      end
    end

    defp adapt(%{"timestamp" => timestamp} = data) do
      data
        |> Map.new(fn {k, v} -> {String.to_atom(Macro.underscore(k)), v} end)
        |> Map.put(:market_type, determine_type(timestamp))
    end

    defp determine_type(timestamp) do
      {:ok, datetime, _offset} = DateTime.from_iso8601(timestamp)
      time = {datetime.hour, datetime.minute}

      type = case time do
        {h, _m} when h < 9 -> "pre-market"
        {h, m} when h == 9 and m < 30 -> "pre-market"
        {h, _m} when h <= 16 -> "regular"
        {h, _m} when h <= 20 -> "after-hours"
        _ -> "unknown"
      end

      type
    end
end
