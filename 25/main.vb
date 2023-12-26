Option Infer On
Imports System.Linq

Imports System.Collections.Generic

Module Main
  Function Parse(ByVal fileName As String) As (HashSet(Of String), List(Of (String, String)))
    Dim components As New HashSet(Of String)
    Dim wires As New List(Of (String, String))
    Dim lines = System.IO.File.ReadAllLines(fileName)
  
    For i As Integer = 0 To lines.Length - 1
      Dim splitted = lines(i).Split(":"c)
      Dim component = splitted(0).Trim()
      components.Add(component)
      Dim targets = splitted(1).Trim().Split(" "c)
      For j = 0 To targets.Length - 1
        Dim target = targets(j).Trim()
        wires.Add((component, target))
        components.Add(target)
      Next
    Next
    Return (components, wires)
  End Function
  
  Function countConnectedNodes(nodes As HashSet(Of String), wires As HashSet(Of (String, String))) As Integer
    Dim count = 0
    For Each w in wires
        If nodes.Contains(w.Item1) Or nodes.Contains(w.Item2)
          count = count + 1
        End If
    Next
    Return count
  End Function
  
  Function countUnconnectedNodes(nodes As HashSet(Of String), wires As HashSet(Of (String, String))) As Integer
    Dim count = 0
    For Each w in wires
        If (not nodes.Contains(w.Item1)) Or (not nodes.Contains(w.Item2))
          count = count + 1
        End If
    Next
    Return count
  End Function
  
  Function findPartition(wireMap As Dictionary(Of String, HashSet(Of (String, String)))) As HashSet(Of String) 
    Dim partition As New HashSet(Of String)
    Dim otherNodes As New HashSet(Of String)(wireMap.Keys)
  
    Dim startNode = otherNodes.First()
    
    partition.Add(startNode)
    otherNodes.Remove(startNode)
  
    while otherNodes.Count > 0
  
      Dim maxNode = Nothing
      Dim maxCount = 0
  
      For Each key in otherNodes
        Dim wires = wireMap(Key)
        Dim c = countConnectedNodes(partition, wires)
        If c > maxCount
          maxCount = c
          maxNode = key
        End If
      Next
  
      partition.Add(maxNode)
      otherNodes.Remove(maxNode)
  
      Dim sumUnconnected = 0
      For Each n in partition
        sumUnconnected = sumUnconnected + countUnconnectedNodes(partition, wireMap(n))
      Next
  
      If sumUnconnected = 3
        Return partition
      End If
  
    End While
  
    Return Nothing
  End Function
  
 
  Sub Solve(components As HashSet(Of String), wires As List(Of (String, String)))
    Dim wireMap As New Dictionary(Of String, HashSet(Of (String, String)))
  
    For Each wire In wires
      Dim items As New List(Of String) From { wire.Item1, wire.Item2 }

      For Each item in items
        If wireMap.ContainsKey(item) Then
          wireMap(item).Add(wire)
        Else       
          wireMap.Add(item, New HashSet(Of (String, String)) From {wire})
        End If
      Next
    Next
  
    Dim result = findPartition(wireMap)
    System.Console.WriteLine((components.Count - result.Count) * result.Count)
 
  End Sub

	Sub Main()
      Dim result = Parse("input")
      Dim components = result.Item1
      Dim wires = result.Item2
      Solve(components, wires)
  End Sub
End Module
