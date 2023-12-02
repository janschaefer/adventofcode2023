#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <vector>
#include <map>

using namespace std;


vector<string> parseFile(string filename) {
  ifstream file(filename);
  vector<string> lines;
  string line;
  while (getline(file, line)) {
    lines.push_back(line);
  }
  return lines;
}

vector<string> splitString(string str, char c) {
    vector<string> result;
    stringstream ss(str);
    string item;
    while (getline(ss, item, c)) {
        result.push_back(item);
    }
    return result;
}

bool isSetPossible(string set, map<std::string, int> maxColors) {
  vector<string> colorStrings = splitString(set, ',');

  for (string colorString: colorStrings) {
    vector<string> colorParts = splitString(colorString, ' ');
    string colorCount = colorParts[1];
    int color = stoi(colorCount);
    if (color > maxColors[colorParts[2]]) {
      return false;
    }
  }  
  return true;
}

bool isGamePossible(string line, map<std::string, int> maxColors) {
  vector<string> setParts = splitString(line, ';');

  for (string set: setParts) {
     if (!isSetPossible(set, maxColors)) {
        return false;
     }
  }
  
  return true;
}

int solve(string filename) {
  vector<string> lines = parseFile(filename);

  map<std::string, int> maxColors;

  maxColors["red"] = 12;
  maxColors["green"] = 13;
  maxColors["blue"] = 14;

  int sum = 0;

  for (string line : lines) {

    vector<string> parts = splitString(line, ':');
    string gameIdString = splitString(parts[0], ' ')[1];
    int gameId = stoi(gameIdString);

    if (isGamePossible(parts[1], maxColors)) {
      sum = sum + gameId;
    }
  }

  return sum;
}

void updateMinColors(string set, map<string, int>& minColors) {
  vector<string> colorStrings = splitString(set, ',');

  for (string colorString: colorStrings) {
    vector<string> colorParts = splitString(colorString, ' ');
    string colorCount = colorParts[1];
    int color = stoi(colorCount);
    if (color > minColors[colorParts[2]]) {
      minColors[colorParts[2]] = color;
    }
  }  
}

int powerOfMinimumSetOfCubes(string line) {
  vector<string> setParts = splitString(line, ';');

  map<string, int> minColors;

  minColors["red"] = 0;
  minColors["green"] = 0;
  minColors["blue"] = 0;

  for (string set: setParts) {
     updateMinColors(set, minColors);
  }

  return minColors["red"] * minColors["green"] * minColors["blue"];
}

int solve2(string filename) {
  vector<string> lines = parseFile(filename);

  map<string, int> maxColors;

  int sum = 0;

  for (string line : lines) {
    vector<string> parts = splitString(line, ':');
    string gameIdString = splitString(parts[0], ' ')[1];
    int power = powerOfMinimumSetOfCubes(parts[1]);
    sum = sum + power;
  }

  return sum;
}


int main() {
  cout << solve("input") << endl;
  cout << solve2("input2") << endl;
}
