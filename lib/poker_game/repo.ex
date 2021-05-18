defmodule PokerGame.Repo do
  use Ecto.Repo,
    otp_app: :poker_game,
    adapter: Ecto.Adapters.Postgres
end
