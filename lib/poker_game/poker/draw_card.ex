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
        [diff_value_pair({cards_a, "black"}), diff_value_pair({cards_b, "white"})],
        fn {_player, _card, index} -> index end
      )

    "#{player} wins - pair: #{name(card)}"
  end

  def diff_value_pair({cards, player}) do
    dup_values = return_duplicate_value(cards)
    [{card, index}] = Enum.filter(ranked_cards(), fn {card, _value} -> card in dup_values end)

    {player, card, index}
  end

  # def pair_rank_same_values() do
  # end

  def same_value_pair(%{black: cards_a, white: cards_b}) do
    #Add check to ensure values are the same
    [h|_] = List.flatten([return_duplicate_value(cards_a), return_duplicate_value(cards_b)])
    new_card_a = drop_duplicates({cards_a, h})
    new_card_b = drop_duplicates({cards_b, h})
    {player, card, _index} = Enum.max_by([high_card({new_card_a, "black"}), high_card({new_card_b, "white"})], fn {_player, _card, index} -> index end)
    "#{player} wins - pair: #{name(card)}"
  end

  def drop_duplicates({cards, card}) when is_list(cards) do
    return_cards_values(cards) 
    |> Enum.filter(fn x  -> x != card end)
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

  defp ranked_cards() do
    Enum.zip(@cards, 1..13)
  end

  defp name("J"), do: "Jack"
  defp name("Q"), do: "Queen"
  defp name("K"), do: "King"
  defp name("A"), do: "Ace"
  defp name(value), do: value
end
