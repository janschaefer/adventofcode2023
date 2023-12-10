defmodule Main do 
  def calculateDistance(buttonTime, totalTime) do
    travelTime = totalTime - buttonTime
    buttonTime * travelTime
  end
  
  def waysToBeatTheRecord(race) do
   totalTime = elem(race,0)
   recordDistance = elem(race,1)
   allDistances = Enum.map(Enum.to_list(1..totalTime-1),
      fn buttonTime -> calculateDistance(buttonTime, totalTime) end)
   betterDistances = allDistances |> Enum.filter(fn distance -> distance > recordDistance end) |> length()
   betterDistances
  end

  def waysToBeatTheRecord2(race) do
    totalTime = elem(race,0)
    recordDistance = elem(race,1)
    bestTime = round(totalTime / 2)

    betterDistances = 0..bestTime
      |> Stream.map( fn x -> calculateDistance( bestTime - x, totalTime) end)
      |> Stream.take_while( fn distance -> distance > recordDistance end)
    
    if rem(totalTime, 2) == 0 do
      Enum.count(betterDistances) * 2 - 1
    else
      Enum.count(betterDistances) * 2 - 2
    end
  end
end

# list of races where the first element is in ms and the second in mm
#example = [{7,9}, {15,40}, {30,200}]
#example2 = {71530,940200}

# as the input was so small I did not implement the parsing ;-)
input = [{38, 234}, {67, 1027}, {76, 1157}, {73, 1236}]
input2 = {38677673, 234102711571236}

result = Enum.map(input, &Main.waysToBeatTheRecord/1 ) |> Enum.reduce(1, fn a,b -> a*b end)
result2 = Main.waysToBeatTheRecord2(input2)

IO.inspect(result)
IO.inspect(result2)
