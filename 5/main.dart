import 'dart:io';

Future<List<String>> readLinesFromFile(String filePath) async {
  File file = File(filePath);
  List<String> lines = await file.readAsLines();
  return lines;
}

class Range {
  int destination;
  int source;
  int range;

  Range(this.destination, this.source, this.range);
}

class Input {
  List<int> seeds;
  List<String> maps;
  Map<String, List<Range>> ranges;
  
  Input(this.seeds, this.maps, this.ranges);  
}

Input parseLines(List<String> lines) {
  String seedLine = lines[0];
  List<int> seeds = seedLine.split(':')[1].trim().split(' ').map((s) => int.parse(s)).toList();

  Map<String, List<Range>> ranges = new Map();
  List<Range> currentRanges = [];
  List<String> maps = [];
  
  lines.sublist(2).forEach((s) {
    if (s.trim().endsWith('map:')) {
      currentRanges = [];
      ranges[s.trim()] = currentRanges;
      maps.add(s);
    } else if (s.trim() != '') {
      List<int> ranges = s.trim().split(' ').map((s) => int.parse(s)).toList();
      currentRanges.add(new Range(ranges[0], ranges[1], ranges[2]));
    }
  });

  return new Input(seeds, maps, ranges);
}

int mapNumber(int number, List<Range>? ranges) {
  int destination = number;
  ranges!.forEach( (r) {
    if (number >= r.source && number < (r.source + r.range)) {
      destination = (number - r.source) + r.destination;
    }
  });
  
  return destination;
}

int calculateLocation(int seed, List<String> maps, Map<String, List<Range>> ranges) {
  int currentNumber = seed;
  maps.forEach( (m) {
    currentNumber = mapNumber(currentNumber, ranges[m]);
  });
  
  return currentNumber;
}

void solve(String filePath) async {
  List<String> lines = await readLinesFromFile(filePath);
  Input input = parseLines(lines);
  List<int> locations = input.seeds.map( (s) => calculateLocation(s, input.maps, input.ranges)).toList();
  locations.sort();
  print(locations[0]);
}

int mapNumberReverse(int number, List<Range>? ranges) {
  int source = number;
  ranges!.forEach( (r) {
    if (number >= r.destination && number < (r.destination + r.range)) {
      source = (number - r.destination) + r.source;
    }
  });

  return source;
}

int calculateSeed(int location, List<String> maps, Map<String, List<Range>> ranges) {
  int currentNumber = location;
  maps.reversed.forEach( (m) {
    currentNumber = mapNumberReverse(currentNumber, ranges[m]);
  });

  return currentNumber;
}

bool inStartSeeds(seed, List<int> startSeeds) {
  for (int i = 0; i < startSeeds.length / 2; i+=2) {
    if (seed >= startSeeds[i] && seed < (startSeeds[i] + startSeeds[i+1])) {
      return true;
    }
  }
  return false;
}

void solve2(String filePath) async {
  List<String> lines = await readLinesFromFile(filePath);
  Input input = parseLines(lines);

  List<Range>? locationRanges = input.ranges['humidity-to-location map:'];
  locationRanges!.sort( (r1, r2) => r1.destination - r2.destination);

  // this is quite a hack ;-)
  for (int location = 0; location < 100000000; location++) {
    int seed = calculateSeed(location, input.maps, input.ranges);
    if (inStartSeeds(seed, input.seeds)) {
      print(location);
      return;
    }
  }  
}

void main()  {
  solve("input");
  solve2("input");
}
