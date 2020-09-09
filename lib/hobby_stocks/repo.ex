defmodule HobbyStocks.Repo do
  use Ecto.Repo,
    otp_app: :hobby_stocks,
    adapter: Ecto.Adapters.Postgres
end
