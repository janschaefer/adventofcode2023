open System;
open System.Numerics;

let rec parseNodeMap (networkLines: string[]) (nodeMap: Map<string, (string * string)>) : Map<string, (string * string)> =
  if networkLines.Length = 0 then
    nodeMap
  else
    let currentLine = networkLines.[0]
    let keyAndRest = currentLine.Split('=')
    let key = keyAndRest.[0].Trim()
    let leftAndRight = keyAndRest.[1].Split(',')
    let left = leftAndRight.[0].Trim().[1..];
    let rightPart = leftAndRight.[1].Trim();
    let right = rightPart.[0..(rightPart.Length - 2)];
    let newMap = nodeMap.Add(key, (left, right))
    let nodeMap = parseNodeMap networkLines.[1..] newMap
    nodeMap

let rec followNetwork (currentKey: string) (directions: string) (nodeMap: Map<string, (string * string)>) (count: int): int =
  if currentKey.EndsWith("Z") then
    count
  else
    let direction = directions.[count % directions.Length]
    let nextKey = 
      if direction = 'L' then
        fst nodeMap.[currentKey]
      else
        snd nodeMap.[currentKey]
    followNetwork nextKey directions nodeMap (count + 1)
    
let lcm a b =
  let gcd = BigInteger.GreatestCommonDivisor(a, b)
  (BigInteger.Abs(a * b)) / gcd

// SCM of a list of numbers
let rec scm numbers: BigInteger =
    match numbers with
    | [] -> 1
    | [x] -> x
    | x :: xs -> lcm x (scm xs)


let solve (directions: string) (nodeMap: Map<string, (string * string)>) =
  let totalSteps = followNetwork "AAA" directions nodeMap 0
  printfn "%i" totalSteps
  
let solve2 (directions: string) (nodeMap: Map<string, (string * string)>) =  
  let startKeys = 
    nodeMap 
    |> Map.keys 
    |> Seq.filter (fun key -> key.EndsWith("A"))
    |> Seq.toArray

  let totals = 
    startKeys 
    |> Array.map (fun key -> BigInteger(followNetwork key directions nodeMap 0))
    
  let lcmValue = scm (Seq.toList totals)
  printfn "%A" lcmValue



[<EntryPoint>]
let main argv =
  let lines = System.IO.File.ReadAllLines("input")
  let directions = lines.[0]
  let nodeMap = parseNodeMap lines.[2..] Map[]
  
  solve directions nodeMap
  solve2 directions nodeMap
  0 
