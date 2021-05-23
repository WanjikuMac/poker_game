defmodule PokerGame.DrawCard do
  require Logger
  @cards ~w(2 3 4 5 6 7 8 9 T J Q K A)
  # define the data structure
  defstruct [:black, :white]

  # create constructor
  # A hand only contains 5 cards
  def new(cards_a, cards_b) do
    %__MODULE__{black: cards_a, white: cards_b}
  end

  # HIGH CARD AND FLUSH RANKING
  # create convertor for high card
  def high_card(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by([high_card({cards_a, "black"}), high_card({cards_b, "white"})], fn {_player,
                                                                                      _card,
                                                                                      index} ->
        index
      end)

    "#{player} wins - high card: #{name(card)}"
  end

  # create reducer for high card ranking 
  def high_card({cards, player}) when is_list(cards) do
    result = return_cards_values(cards)
    # use max_by
    {card, index} = Enum.filter(ranked_cards(), fn {card, _y} -> card in result end) |> Enum.max()
    {player, card, index}
  end

  # ranking order of pair 
  def pair_rank_diff_values(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by(
        List.flatten([diff_value_pair({cards_a, "black"}), diff_value_pair({cards_b, "white"})]),
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - pair: #{name(card)}"
  end

  def diff_value_pair({cards, player}) do
    Enum.filter(ranked_cards(), fn {card, _value} -> card in return_duplicate_value(cards) end)
    |> Enum.map(fn {card, index} -> {player, card, index} end)
  end

  # Todo review this function later
  def same_value_pair(%{black: cards_a, white: cards_b}) do
    # Add check to ensure values are the same
    [h, _] = [return_duplicate_value(cards_a), return_duplicate_value(cards_b)]
    new_card_a = drop_duplicates({cards_a, h})
    new_card_b = drop_duplicates({cards_b, h})

    {player, card, _index} =
      Enum.max_by(
        [high_card({new_card_a, "black"}), high_card({new_card_b, "white"})],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - pair: #{name(card)}"
  end

  # TWO PAIR RANKING
  def two_pair_same_values(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by(
        [
          high_card({two_pair_same_values(cards_a), "black"}),
          high_card({two_pair_same_values(cards_b), "white"})
        ],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - Two pair: #{name(card)}"
  end

  def two_pair_same_values(cards) when is_list(cards) do
    drop_duplicates({cards, return_duplicate_value(cards)})
  end

  def two_pair_rank(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      List.flatten(two_pair_rank({cards_a, "black"}), two_pair_rank({cards_b, "white"}))
      |> Enum.max_by(fn {_player, _card, index} -> index end)

    "#{player} wins - Two pairs: #{name(card)}"
  end

  def two_pair_rank({cards, player}) when is_list(cards) do
    Enum.filter(ranked_cards(), fn {card, _value} -> card in return_duplicate_value(cards) end)
    |> Enum.map(fn {card, index} -> {player, card, index} end)
  end

  # THREE OF A KIND RANKING
  def three_of_a_kind(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by(
        [
          high_card({return_duplicate_value(cards_a), "black"}),
          high_card({return_duplicate_value(cards_b), "white"})
        ],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - Three of a kind: #{name(card)}"
  end

  # STRAIGHT Hand contains 5 cards with consecutive values.
  # TODO Add check to ensure the cards are consecutive
  def straight(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by([high_card({cards_a, "black"}), high_card({cards_b, "white"})], fn {_player,
                                                                                      _card,
                                                                                      index} ->
        index
      end)

    "#{player} wins - Straight: #{name(card)}"
  end

  # FOUR OF A KIND
  def four_of_a_kind(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by(
        [
          high_card({return_duplicate_value(cards_a), "black"}),
          high_card({return_duplicate_value(cards_b), "white"})
        ],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - Four of a kind: #{name(card)}"
  end

  # STRAIGHT FLUSH
  # TODO Add check to ensure the cards are consecutive
  def straight_flush(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by([high_card({cards_a, "black"}), high_card({cards_b, "white"})], fn {_player,
                                                                                      _card,
                                                                                      index} ->
        index
      end)

    "#{player} wins - Straight Flush: #{name(card)}"
  end

  # FULL HOUSE
  def full_house(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by(
        [
          high_card({return_three_duplicate_value(cards_a), "black"}),
          high_card({return_three_duplicate_value(cards_b), "white"})
        ],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - Full House: #{name(card)}"
  end

  def drop_duplicates({cards, dup_card}) when is_list(cards) do
    return_cards_values(cards)
    |> Enum.filter(fn x -> x not in dup_card end)
  end

  def return_three_duplicate_value(cards) do
    return_cards_values(cards)
    |> Enum.group_by(& &1)
    |> Enum.filter(fn x -> match?({_, [_, _, _]}, x) end)
    |> Enum.map(fn {x, _} -> x end)
  end

  def return_duplicate_value(cards) when is_list(cards) do
    return_cards_values(cards)
    |> Enum.group_by(& &1)
    |> Enum.filter(fn x -> match?({_, [_, _ | _]}, x) end)
    |> Enum.map(fn {x, _} -> x end)
  end

  def return_cards_values(cards) do
    cards
    |> Enum.map(fn x -> String.split_at(x, 1) end)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def ranked_cards() do
    Enum.zip(@cards, 1..13)
  end

  defp name("J"), do: "Jack"
  defp name("Q"), do: "Queen"
  defp name("K"), do: "King"
  defp name("A"), do: "Ace"
  defp name(value), do: value
end
