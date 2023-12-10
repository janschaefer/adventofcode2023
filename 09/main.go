package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
)

func parseFile(filePath string) ([][]int) {
    data, _ := ioutil.ReadFile(filePath)
    lines := strings.Split(string(data), "\n")
    var result [][]int
    for _, s := range lines {
        var historyValues []int
        for _, substr := range strings.Fields(s) {
            val, _ := strconv.Atoi(substr) // Conversion to int, ignoring errors
            historyValues = append(historyValues, val)
        }
        result = append(result, historyValues)
    }
    return result;
}

func allZero(nums []int) bool {
    for _, num := range nums {
        if num != 0 {
            return false
        }
    }
    return true
}

func calcDifferences(nums []int) []int {
  differences := make([]int, len(nums)-1)
  for i := 0; i < len(nums)-1; i++ {
      differences[i] = nums[i+1] - nums[i]
  }

  return differences
}

func predictNextValue(history []int) (int) {
  if (allZero(history)) {
    return 0
  }

  differences := calcDifferences(history)
  next := predictNextValue(differences)
  lastValue := history[len(history)-1]
  return lastValue + next
}

func predictPreviousValue(history []int) (int) {
  if (allZero(history)) {
    return 0
  }

  differences := calcDifferences(history)
  next := predictPreviousValue(differences)
  lastValue := history[0]
  return lastValue - next
}


func solve(input [][]int) {
  var sum = 0
  for _, history := range input {
    sum += predictNextValue(history)

  }
  fmt.Println(sum)
}

func solve2(input [][]int) {
  var sum = 0
  for _, history := range input {
    sum += predictPreviousValue(history)

  }
  fmt.Println(sum)
}


func main() {
  input := parseFile("input")
  solve(input)
  solve2(input)
}
