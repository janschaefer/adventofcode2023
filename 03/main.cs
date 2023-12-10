using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;

class Program {

  public static bool IsNextToSymbol(int lineIndex, int start, int end, bool[,] symbols) {
    int fromY = Math.Max(lineIndex - 1, 0);
    int toY = Math.Min(lineIndex + 2, symbols.GetLength(0));
    for (int y = fromY; y < toY; y++) {
      int fromX = Math.Max(0, start - 1);
      int toX = Math.Min(end + 1, symbols.GetLength(1));
      for (int x = fromX; x < toX; x++) {
        if (symbols[y,x]) {
          return true;
        }
      }
    }
    return false;
  }
  
  public static int GetSumOfAllPartNumbers(string[] lines, bool[,] symbols) {
    int sum = 0;
    for (int y = 0; y < lines.Length; y++) {
    
      string pattern = @"(\d+)";
      MatchCollection matches = Regex.Matches(lines[y], pattern);
      foreach (Match match in matches) {
        if (int.TryParse(match.Value, out int number)) {
          int start = match.Index;
          int end = match.Index + match.Length;
          if (IsNextToSymbol(y, start, end, symbols)) {
            sum = sum + number;
          }
        };
      }
    }
    return sum;
  }

  public static bool[,] ParseSymbols(string[] lines) {
    int lineLength = lines[0].Length;
    bool[,] symbols = new bool[lines.Length, lineLength];
    
    for (int y = 0; y < lines.Length; y++) {
      for (int x = 0; x < lineLength; x++) {
        char c = lines[y][x];
        if ((! char.IsDigit(c)) && c != '.') {
          symbols[y,x] = true;
        } else {
          symbols[y,x] = false;
        }
      }
    }
    return symbols;
  }

  public static void AddToGear(int lineIndex, int start, int end, int number, Gear[,] gears) {
    int fromY = Math.Max(lineIndex - 1, 0);
    int toY = Math.Min(lineIndex + 2, gears.GetLength(0));
    for (int y = fromY; y < toY; y++) {
      int fromX = Math.Max(0, start - 1);
      int toX = Math.Min(end + 1, gears.GetLength(1));
      for (int x = fromX; x < toX; x++) {
        Gear gear = gears[y,x];
        if (gear != null) {
          gear.numbers.Add(number);
        }
      }
    }
  }

  
  public static int GetSumOfAllGearRatios(string[] lines, Gear[,] gears) {
    for (int y = 0; y < lines.Length; y++) {
      string pattern = @"(\d+)";
      MatchCollection matches = Regex.Matches(lines[y], pattern);
      foreach (Match match in matches) {
        if (int.TryParse(match.Value, out int number)) {
          int start = match.Index;
          int end = match.Index + match.Length;
          AddToGear(y, start, end, number, gears);
        };
      }
    }

    int sum = 0;

    for (int y = 0; y < gears.GetLength(0); y++) {
      for (int x = 0; x < gears.GetLength(1); x++) {
        Gear gear = gears[y,x];
        if (gear != null) {
          if (gear.numbers.Count == 2) {
            sum += (gear.numbers[0] * gear.numbers[1]);
          }
        }
      }
    }
    
    return sum;
  }

  public class Gear {
    public List<int> numbers = new List<int>();
  }

  public static Gear[,] ParseGears(string[] lines) {
    int lineLength = lines[0].Length;
    Gear[,] gears = new Gear[lines.Length, lineLength];

    for (int y = 0; y < lines.Length; y++) {
      for (int x = 0; x < lineLength; x++) {
        char c = lines[y][x];
        if (c == '*') {
          Gear gear = new Gear();
          gears[y,x] = gear;
        } else {
          gears[y,x] = null;
        }
      }
    }
    return gears;
  }


  public static void Solve (string filename) {
    string[] lines = File.ReadAllLines(filename);
    bool[,] symbols = ParseSymbols(lines);
    
    int sum = GetSumOfAllPartNumbers(lines, symbols);
    Console.WriteLine(sum);
  }

  public static void Solve2 (string filename) {
    string[] lines = File.ReadAllLines(filename);
    Gear[,] gears = ParseGears(lines);

    int sum = GetSumOfAllGearRatios(lines, gears);
    Console.WriteLine(sum);
  }

  public static void Main (string[] args) {
    Solve("input");
    Solve2("input");
  }
}
