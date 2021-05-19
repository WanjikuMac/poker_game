defmodule PokerGame.DrawCardTest do
  use ExUnit.Case
  import PokerGame.DrawCard

  test "card scores with high card criteria" do
    result  = new(~w(2H 3D 5S 9C KD), ~w(2C 3H 4S 8C AH))
              |> high_card()
    assert result == "white wins - high card: Ace"
  end
end
