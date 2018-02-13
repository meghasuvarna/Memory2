  defmodule Memory.Game do
  def createCards() do

    ["A", "B", "C", "D", "E", "F", "G", "H", "A", "B", "C", "D", "E", "F", "G", "H"]
    |> Enum.shuffle()
    |> Enum.map(fn a -> %{
                          :flipped=>false,
                          :rowIndex=> 0,
                          :colIndex=> 0,
                          :value=> a,
                          :mode=> 1}
                           end)
    |> Enum.chunk_every(4)
    |> createTwoDimArray()
  end

  def createTwoDimArray(list)

  do
  rowCol = []
  for x <- 0..3, do: 
  for y <- 0..3, do:
      
    Map.replace!(Enum.at(Enum.at(list,x),y), :rowIndex, x)
    |> Map.replace!(:colIndex, y)
  
end


  def new do
  %{      
     cards: createCards(), 
     firstInput: nil,
     secondInput: nil,
     firstCardValue: "",
     mode: 1,
     clicks: 0,
     score: 0
   }

  end



  def cardClick(state,row,col) do
    
    count = state.clicks + 1
    card = Enum.at(Enum.at(state.cards,row),col)
    
    IO.inspect(card)
    IO.inspect(state.firstCardValue)
    
    
     currentScore = state.score
    
       
     case state.mode do
         1 ->   
                
               card = Map.replace!(card, :flipped, true)
                
                 replacedSet = List.replace_at(Enum.at(state.cards,row),col,card)
                 updatedCards = List.replace_at(state.cards,row,replacedSet)
                 IO.inspect(updatedCards)
                            
             
                
                   %{ 
                      cards: updatedCards,
                      firstInput: card,
                      secondInput: state.secondInput,
                      firstCardValue: card.value,
                      score: currentScore,
                      mode: 2,
                      clicks: count
     
                   }
         2 ->  
                 card = Map.replace!(card, :flipped, true)
                 IO.inspect(card)
                 replacedSet = List.replace_at(Enum.at(state.cards,row),col,card)
                 updatedCards = List.replace_at(state.cards,row,replacedSet)
                 IO.inspect(updatedCards)
            
                
                    if(state.firstCardValue == card.value) do
                
                    currentScore = currentScore + 20
                  %{ 
                      cards: updatedCards,
                      firstInput: state.firstInput,
                      secondInput: card,
                      firstCardValue: state.firstCardValue,
                      score: currentScore,
                      mode: 1,
                      clicks: count
     
                   }
              else
                    %{
                      cards: updatedCards,
                      firstInput: state.firstInput,
                      secondInput: card,
                      firstCardValue: state.firstCardValue,
                      score: currentScore,
                      mode: 4,
                      clicks: count
                      }

              end
         4 -> if (currentScore <= 0) do
                 currentScore = 0
               else
                 currentScore = currentScore - 5
               end
                 IO.puts("reached")

                 firstCard = Map.replace!(state.firstInput, :flipped, false)
                 secondCard = Map.replace!(state.secondInput, :flipped, false)
               
                 replacedSet1 = List.replace_at(Enum.at(state.cards,firstCard.rowIndex),firstCard.colIndex,firstCard)
                 updatedCards = List.replace_at(state.cards,firstCard.rowIndex,replacedSet1)
                 IO.inspect(updatedCards)
                 replacedSet2 = List.replace_at(Enum.at(updatedCards,secondCard.rowIndex),secondCard.colIndex,secondCard)
                 updatedCards = List.replace_at(updatedCards,secondCard.rowIndex,replacedSet2)
                 IO.inspect(updatedCards)
                 
               %{
                      cards: updatedCards,
                      firstInput: [],
                      secondInput: [],
                      firstCardValue: "",
                      score: currentScore,
                      mode: 1,
                      clicks: count
                }


     
 
   end
    end
  end
