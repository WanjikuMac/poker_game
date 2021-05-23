defmodule PokerGame.DrawCardTest do
  use ExUnit.Case
  import PokerGame.DrawCard

  test "high_card/1" do
    white_player = ~w(2C 3H 4S 8C AH)
    black_player = ~w(2H 3D 5S 9C KD)

    result =
      new(black_player, white_player)
      |> high_card()

    assert result == "white wins - high card: Ace"
  end
  test "pair_card" do
    white_player = ~w(2C 2H 4S 8C AH)
    black_player = ~w(3H 3D 5S 9C KD)

    result = 
      new(black_player, white_player)
      |> pair_rank_diff_values()

      assert result == "black wins - pair: 3"
  end

  test "same value pair card" do
    white_player = ~w(3C 3H 4S 8C AH)
    black_player = ~w(3H 3D 5S 9C KD)

    new(black_player, white_player)
    |> same_value_pair()
  end

  test "two pairs same value card/1" do
    white_player = ~w(3C 3H 3S 3C AH)
    black_player = ~w(3H 3D 3S 3C KD)

    result = new(black_player, white_player)
            |> two_pair_same_values()
           
    assert result == "white wins - Two pair: Ace"
  end

  test "two pairs same value card/2" do
    white_player = ~w(3C 3H 8S 8C KH)
    black_player = ~w(3H 3D 9S 9C AD)

    result  = new(black_player, white_player)
              |> two_pair_rank()
    assert result == "black wins - Two pairs: 9"
  end

  test "three of a kind" do
    white_player = ~w(3C 3H 3S 8C KH)
    black_player = ~w(8H 8D 8S 9C AD)

    result  = new(black_player, white_player)
              |> three_of_a_kind()
    assert result == "black wins - Three of a kind: 8"
  end

  test "straight" do
    white_player = ~w(3C 4H 5S 6C 7H)
    black_player = ~w(4H 5D 6S 7C 8D)

    result  = new(black_player, white_player)
              |> straight()
             
    assert result == "black wins - Straight: 8"
  end

  test "four of a kind" do
    white_player = ~w(4C 4H 4S 4C KH)
    black_player = ~w(3H 3D 3S 3C AD)

    result  = new(black_player, white_player)
              |> four_of_a_kind()

    assert result == "white wins - Four of a kind: 4"
  end

  test "straight flush" do
    white_player = ~w(3C 4C 5C 6C 7C)
    black_player = ~w(2H 3D 4S 5C 6D)

    result  = new(black_player, white_player)
              |> straight_flush()

    assert result == "white wins - Straight Flush: 7"
  end

  test "full house" do
    white_player = ~w(3C 3H 3S 8C 8H)
    black_player = ~w(4H 4D 4S 9C 9D)

    result  = new(black_player, white_player)
              |> full_house()

    assert result == "black wins - Full House: 4"
  end
end
