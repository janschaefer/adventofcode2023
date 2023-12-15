const fs = require("fs");

function parseLine(l) {
  const parts = l.split(" ");

  return {
    conditionRecord: parts[0].split(""),
    groups: parts[1].split(",").map(Number),
  };
}

function parseFile(filename, fun) {
  fs.readFile(filename, "utf8", (err, data) => {
    const lines = data.split(/\r?\n/).map(parseLine);
    fun(lines);
  });
}

function getGroupsFromRecord(conditionRecord) {
  const groups = [];
  let group = false;
  let currentGroup = 0;
  for (let char of conditionRecord) {
    if (char === ".") {
      if (group) {
        group = false;
        groups.push(currentGroup);
      }
    } else if (char === "#") {
      if (group) {
        currentGroup++;
      } else {
        group = true;
        currentGroup = 1;
      }
    }
  }

  if (group) {
    groups.push(currentGroup);
  }

  return groups;
}

function matchesCondition(conditionRecord, compareGroups) {
  const groups = getGroupsFromRecord(conditionRecord);
  if (groups.length !== compareGroups.length) {
    return false;
  }
  for (let i = 0; i < groups.length; i++) {
    if (groups[i] !== compareGroups[i]) {
      return false;
    }
  }
  return true;
}

function possibleArrangements(conditionRecord, groups) {
  const arrangements = [];
  const numberUnknowns = conditionRecord.filter((g) => g === "?").length;
  for (let i = 0; i < Math.pow(2, numberUnknowns); i++) {
    const arrangement = [];
    let j = 0;
    for (let p = 0; p < conditionRecord.length; p++) {
      const c = conditionRecord[p];
      if (c === "?") {
        if (i & (1 << j)) {
          arrangement.push("#");
        } else {
          arrangement.push(".");
        }
        j++;
      } else {
        arrangement.push(c);
      }
    }
    if (matchesCondition(arrangement, groups)) {
      arrangements.push(arrangement);
    }
  }

  return arrangements.length;
}

function possibleArrangements2Group(cache, pattern, groups, i, j) {
  if (j === groups.length) {
    return 0;
  }

  let group = groups[j];

  // we are already at the first damaged spring, so start at 1
  for (let k = 1; k < group; k++) {
    i++;
    if (i === pattern.length || pattern[i] === ".") {
      return 0;
    }    
  }

  i++;

  // after a damaged spring there must come an operational spring
  if (i < pattern.length && pattern[i] === "#") {
    return 0;
  }

  return possibleArrangements2Cached(cache, pattern, groups, i + 1, j + 1);
}

function possibleArrangements2Cached(cache, pattern, groups, i, j) {
  let key = i + '_' + j;
  let res;
  if (!cache.has(key)) {
    res = possibleArrangements2(cache, pattern, groups, i, j);
    cache.set(key, res);
  } else {
    res = cache.get(key);
  }
  return res;
}

function possibleArrangements2(cache, pattern, groups, i, j) {
  if (i >= pattern.length) {
    if (j === groups.length) {
      return 1;
    }
    return 0;
  }

  const c = pattern[i];
  if (c === ".") {
    return possibleArrangements2Cached(cache, pattern, groups, i + 1, j);
  } else if (c === "#") {
    return possibleArrangements2Group(cache, pattern, groups, i, j);
  } else {
    // c === ?
    let k = possibleArrangements2Cached(cache, pattern, groups, i + 1, j); // treat as . 
    let n = possibleArrangements2Group(cache, pattern, groups, i, j); // treat as #
    return n + k;
  }
}

function unfoldLine(line) {
  return {
    conditionRecord: Array(5).fill(line.conditionRecord.join('')).join('?').split(''),
    groups: Array(5).fill(line.groups).flat(),
  };
}

function solve(lines) {
  const arrangements = lines.map((l) => possibleArrangements(l.conditionRecord, l.groups));
  const sum = arrangements.reduce((total, current) => total + current, 0);
  console.log(sum);
}

function solve2(lines) {
  const unfolded = lines.map(unfoldLine);
  const arrangements = unfolded.map((l) => possibleArrangements2(new Map(), l.conditionRecord, l.groups, 0, 0));
  const sum = arrangements.reduce((total, current) => total + current, 0);
  console.log(sum);
}

parseFile("input", (lines) => {
  solve(lines);
  solve2(lines);
});
