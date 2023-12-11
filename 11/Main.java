import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;

public class Main {

  private static boolean containsColGalaxy(List<List<Character>> universe, int col) {
    for (int i = 0; i < universe.size(); i++) {
      if (universe.get(i).get(col) == '#') {
        return true;
      }
    }
    return false;
  }

  private static void printCharArray(List<List<Character>> array) {
    for (int i = 0; i < array.size(); i++) {
      for (int j = 0; j < array.get(i).size(); j++) {
        System.out.print(array.get(i).get(j) + " ");
      }
      System.out.println();
    }
  }


  public static List<List<Character>> expandUniverse(List<List<Character>> universe) {
    var expandedUniverse = new ArrayList<List<Character>>();
    universe.forEach( row -> {
        expandedUniverse.add(row);
        if (! row.contains('#')) {
          expandedUniverse.add(new ArrayList<>(row));
        }
    });

    int newSize = expandedUniverse.get(0).size();
    for(int col = 0; col < newSize; col++) {
      if (!containsColGalaxy(expandedUniverse, col)) {
        final int c = col;
        expandedUniverse.forEach( row -> {
          row.add(c, '.');
        });
        newSize ++;
        col++;

      }
    }

    return expandedUniverse;
  }
  
  public static List<List<Character>> expandUniverse2(List<List<Character>> universe) {
      for(int i = 0; i < universe.size(); i++) {
        var row = universe.get(i);
        
        if (! row.contains('#')) {
          Collections.fill(row, '+');
        }
      }

    int newSize = universe.get(0).size();
    for(int col = 0; col < newSize; col++) {
      if (!containsColGalaxy(universe, col)) {
        final int c = col;
        for(int row = 0; row < universe.size(); row++) {
           universe.get(row).set(c, '+');
        }
      }
    }
    
    return universe;
  }

  private static List<Character> convertArrayToList(char[] array) {
    var charList = new ArrayList<Character>();
    for (char c : array) {
      charList.add(c);
    }
    return charList;
  }

  public static List<List<Character>> parseFile(String filename) {
    var lines = new ArrayList<List<Character>>();
    try (var reader = new BufferedReader(new FileReader(filename))) {
      String line;
      while ((line = reader.readLine()) != null) {
        lines.add(convertArrayToList(line.toCharArray()));
      }
    } catch (IOException e) {
      e.printStackTrace();
    }

    return lines;
  }

  record Pos(int x, int y) {}

  public static List<Pos> findGalaxies(List<List<Character>> universe) {
    var galaxyPositions = new ArrayList<Pos>();

    for (int y = 0; y < universe.size(); y++) {
      for (int x = 0; x < universe.get(y).size(); x++) {
        if (universe.get(y).get(x) == '#') {
          galaxyPositions.add(new Pos(x,y));
        }
      }
    }
    
    return galaxyPositions;
  }

  public static List<Integer> distances(List<Pos> galaxies) {
    var distances = new ArrayList<Integer>();


    for (int i = 0; i < galaxies.size(); i++) {
      for (int j = i + 1; j < galaxies.size(); j++) {
         var g1 = galaxies.get(i);
         var g2 = galaxies.get(j);        
         var distance = Math.abs(g1.x - g2.x) + Math.abs(g1.y - g2.y);
         distances.add(distance);
      }
    }
    
    return distances;
  }

  public static Integer distanceForChar(Character c, int expandFactor) {
    if (c == '#' || c == '.') {
      return 1;
    } else {
      return expandFactor;
    }

  }
  
  public static Long distance2(List<List<Character>> universe, Pos g1, Pos g2, int expandFactor) {
      Long distance = 0L;
      var fromY = Math.min(g1.y, g2.y);
      var toY = Math.max(g1.y, g2.y);
      var fromX = Math.min(g1.x, g2.x);
      var toX = Math.max(g1.x, g2.x);
    
      for (int y = fromY + 1; y <= toY; y++) {
        var c = universe.get(y).get(fromX);
        distance += distanceForChar(c, expandFactor);
     }

      for (int x = fromX + 1; x <= toX; x++) {
        var c = universe.get(toY).get(x);
        distance += distanceForChar(c, expandFactor);
      }
  
      return distance;
  }
  

  public static List<Long> distances2(List<List<Character>> universe, List<Pos> galaxies, int expandFactor) {
    var distances = new ArrayList<Long>();

    for (int i = 0; i < galaxies.size(); i++) {
      for (int j = i + 1; j < galaxies.size(); j++) {
         var g1 = galaxies.get(i);
         var g2 = galaxies.get(j);        
         var distance = distance2(universe, g1, g2, expandFactor);
         distances.add(distance);
      }
    }

    return distances;
  }
  
  public static void solve(List<List<Character>> universe) {
    var expandedUniverse = expandUniverse(universe);
    var galaxyPositions = findGalaxies(expandedUniverse);
    var distances = distances(galaxyPositions);
    var sum = distances.stream().mapToInt(Integer::intValue).sum();
    System.out.println(sum);
  }

  public static void solve2(List<List<Character>> universe) {
    var expandedUniverse = expandUniverse2(universe);
    var galaxyPositions = findGalaxies(expandedUniverse);
    var distances = distances2(expandedUniverse, galaxyPositions, 1000000);
    var sum = distances.stream().mapToLong(Long::longValue).sum();
    System.out.println(sum);
  }

  public static void main(String[] args) {
    var universe = parseFile("input");
    solve(universe);
    var universe2 = parseFile("input");
    solve2(universe2);
  }
}
