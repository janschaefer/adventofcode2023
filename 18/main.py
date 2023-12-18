def parse(fileName):
  with open(fileName, "r") as f:
    lines = f.readlines()
    words_in_lines = [line.split() for line in lines]
    return words_in_lines

def next_positions(pos, dir, meters):
  if dir == "R":
    return [ [pos[0], pos[1] + meter] for meter in range(meters+1) ]
  elif dir == "L":
    return [ [pos[0], pos[1] - meter] for meter in range(meters+1) ]
  elif dir == "U":
    return [ [pos[0] - meter, pos[1]] for meter in range(meters+1) ]
  elif dir == "D":
    return [ [pos[0] + meter, pos[1]] for meter in range(meters+1) ]
  return []

def dig_positions(words_in_lines):
  positions = []
  pos = [0, 0]
  for line in words_in_lines:
    dir = line[0]
    meters = line[1]
    positions.extend(next_positions(pos, dir, int(meters)))
    pos = positions[-1]
  return positions

def next_pos(pos, dir, meters):
  if dir == "R":
    return (pos[0], pos[1] + meters)
  elif dir == "L":
    return (pos[0], pos[1] - meters)
  elif dir == "U":
    return (pos[0] - meters, pos[1])
  elif dir == "D":
    return (pos[0] + meters, pos[1])

  print(dir)
  raise ValueError("Illegal dir ")

number_to_dir = ['R', 'D', 'L', 'U']

def parse_hex(hex):
  meters = int(hex[2:7], 16)
  dir = number_to_dir[int(hex[7], 16)]
  
  return (dir, int(meters))

def dig_lines(words_in_lines):
  lines = []
  pos = (0, 0)
  for line in words_in_lines:
    (dir, meters) = parse_hex(line[2])
    pos = next_pos(pos, dir, meters)
    lines.append(pos)
  return lines
  
def get_bounds(positions):
  bounds = [0,0,0,0]
  for pos in positions:
    bounds[0] = min(bounds[0], pos[0])
    bounds[1] = min(bounds[1], pos[1])
    bounds[2] = max(bounds[2], pos[0])
    bounds[3] = max(bounds[3], pos[1])
  return bounds

def is_outer(pos, dig_plan, outer_positions):
  row, col = pos
  
  if (row == 0 or col == 0 or row == len(dig_plan) - 1 or col == len(dig_plan[0]) - 1):
    return True
  
  if (row + 1, col) in outer_positions or \
    (row - 1, col) in outer_positions or \
    (row, col + 1) in outer_positions or \
    (row, col - 1) in outer_positions:
    return True
    
  return False

def get_outer_positions(dig_plan, remaining_positions, outer_positions, offset):
  while (True):
    added = 0
    for pos in remaining_positions.copy():
       if is_outer(pos, dig_plan, outer_positions):
         remaining_positions.remove(pos)
         outer_positions.add(pos)
         added += 1
         
    if added == 0:
      return outer_positions

def unset_positions(dig_plan):
  unset_pos = set()
  for row in range(0, len(dig_plan)):
    for col in range(0, len(dig_plan[0])):
      if dig_plan[row][col] == '.':
        unset_pos.add((row, col))
  return unset_pos

def solve(words_in_lines):
  dig_out_positions = dig_positions(words_in_lines)
  bounds = get_bounds(dig_out_positions)
  rowOffset = -bounds[0]
  colOffset = -bounds[1]
  dig_plan = [['.' for col in range(bounds[3] + colOffset + 1)] for row in range(bounds[2] + rowOffset + 1)]
  
  offset_positions = [ [pos[0] + rowOffset, pos[1] + colOffset] for pos in dig_out_positions]
  
  for pos in offset_positions:
    dig_plan[pos[0]][pos[1]] = '#'
  
  unset_pos = unset_positions(dig_plan)

  outer_positions = get_outer_positions(dig_plan, unset_pos, set(), 0)

  for pos in outer_positions:
    dig_plan[pos[0]][pos[1]] = '+'
  
  #for row in dig_plan:
  #  print(' '.join(row))
 
  filled_count = (len(dig_plan) * len(dig_plan[0])) - len(outer_positions)
  print(filled_count)



def solve2(words_in_lines):
  dig_out_lines = dig_lines(words_in_lines)

  # Gauss's area formula to calculate the area of the polygon
  area = 0.5 * abs(sum(x0*y1 - x1*y0 for (x0, y0), (x1, y1) in zip(dig_out_lines, dig_out_lines[1:] + [dig_out_lines[0]])))

  # Add the lines itself as-well
  total_line_length = sum(abs(x1 - x0) + abs(y1 - y0) for (x0, y0), (x1, y1) in zip(dig_out_lines, dig_out_lines[1:] + [dig_out_lines[0]]))

  total = total_line_length / 2 + area + 1;
  print(total)

words_in_lines = parse("input")
solve(words_in_lines)
solve2(words_in_lines)
