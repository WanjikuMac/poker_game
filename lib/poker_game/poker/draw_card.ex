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

  # create convertor
  def high_card(%{black: cards_a, white: cards_b}) do
    {player, card, _index} =
      Enum.max_by([high_card({cards_a, "black"}), high_card({cards_b, "white"})], fn {_player,
                                                                                      _card,
                                                                                      index} ->
        index
      end)

    "#{player} wins - high card: #{name(card)}"
  end

  # create reducer 
  def high_card({cards, player}) when is_list(cards) do
    result =
      cards
      |> Enum.map(fn x -> String.split_at(x, 1) end)
      |> Enum.map(fn x -> elem(x, 0) end)

    {card, index} = Enum.filter(ranked_cards(), fn {card, _y} -> card in result end) |> Enum.max()
    {player, card, index}
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
