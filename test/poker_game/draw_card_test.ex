defmodule PokerGame.DrawCardTest do
  use ExUnit.Case
  import PokerGame.DrawCard

  test "high_card/1" do
    white_player = ~w(2C 3H 4S 8C AH)
    black_player = ~w(2H 3D 5S 9C KD)
    result  = new(black, white)
              |> high_card()
    assert result == "white wins - high card: Ace"
  end
end
