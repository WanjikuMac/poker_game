defmodule PokerGame.DrawCard do 
    require Logger
    @cards ~w(2 3 4 5 6 7 8 9 T J Q K A)
    #define the data structure
    defstruct [:black, :white]

    #create constructor
    #A hand only contains 5 cards
    def new(value_a, value_b) do
     %__MODULE__{black: value_a, white: value_b}
    end

    #create reducer 
    def high_card(%{black: value_a, white: value_b}) do
        
        # high_card(value_a) |> IO.inspect
        # high_card(value_b) |> IO.inspect
     {player, card, _index} = Enum.max_by([high_card({value_a, "black"}), high_card({value_b, "white"})], fn {_player, _card, index} -> index end) 
     
     "#{player} wins - high card: #{name(card)}"
        # Logger.warn("the number of cards drawn are not 5")
    end

    def high_card({value, player}) when is_list(value) do 
       result = value
                |> Enum.map(fn x -> String.split_at(x, 1) end)
                |> Enum.map(fn x -> elem(x, 0) end)
    
        {card, index} = Enum.filter(ranked_cards(), fn ({x, _y}) -> Enum.find(result, fn (x1) -> x1 == x end) end) |> Enum.max() 
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