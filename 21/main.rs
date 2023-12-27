use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::HashSet;
use std::collections::HashMap;
use std::io::{Write};


fn print_2d_array(array: &Vec<Vec<char>>) {
  for row in array {
      for &ch in row {
          print!("{} ", ch);
      }
      println!();
  }
}

fn parse(file_name: &str) -> io::Result<Vec<Vec<char>>> {
    let file = File::open(Path::new(file_name))?;
    let mut array_2d = Vec::new();

    for line in io::BufReader::new(file).lines() {
        let chars = line?.chars().collect();
        array_2d.push(chars);
    }

    Ok(array_2d)
}

fn find_position_of_s(array: &Vec<Vec<char>>) -> Option<(usize, usize)> {
    array.iter().enumerate().find_map(
      |(i, row)| row.iter().position(|&ch| ch == 'S').map(|j| (i, j)))
}

fn check_position_ok(array: &Vec<Vec<char>>, (r, c): (i64, i64)) -> bool {
  if r < 0 || c < 0 || r >= (array.len() as i64) || c >= (array[0].len() as i64) {
    return false
  }

  if array[r as usize][c as usize] == '#' {
    return false
  }
  
  true
}

fn pos_modulo(n: i64, m: usize) -> usize {
  let r = n % (m as i64);
  if r < 0 {
      (r + m as i64) as usize
  } else {
      r as usize
  }
}

fn check_not_rock_infinity(array: &Vec<Vec<char>>, (r, c): (i64, i64)) -> bool {
  if array[pos_modulo(r, array.len())][pos_modulo(c, array[0].len())] == '#' {
    return false
  }

  true
}

fn steps(array: &Vec<Vec<char>>, pos: (i64, i64) ) -> Vec<(i64, i64)> {
  let (r, c) = pos;

  let all_positions = vec![(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)];
  let possible_positions = all_positions.into_iter()
      .filter(|pos| check_position_ok(array, *pos)).collect();
  possible_positions
}

fn steps_infinity(array: &Vec<Vec<char>>, pos: (i64, i64) ) -> Vec<(i64, i64)> {
  let (r, c) = pos;

  let all_positions = vec![(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)];
  all_positions.into_iter()
      .filter(|pos| check_not_rock_infinity(array, *pos)).collect()
}

fn solve(array: &Vec<Vec<char>>) {
  let mut positions = HashSet::new();
  let (start_r, start_c) = find_position_of_s(array).unwrap();
  positions.insert((start_r as i64, start_c as i64));
  for _i in 0..64 {
    let mut new_positions = HashSet::new();
    for pos in &positions {
      new_positions.extend(steps(&array, *pos));
    }
    positions = new_positions;
  }
  println!("{:?}", positions.len());
}

fn write_array_to_file(array_2d: &Vec<Vec<char>>, file_name: &str) -> io::Result<()> {
  let mut file = File::create(file_name)?;

  for row in array_2d {
      for &ch in row {
          write!(file, "{}", ch)?;
      }
      writeln!(file)?; 
  }

  Ok(())
}

fn calc_plots(array: &Vec<Vec<char>>, steps: usize) -> usize {
  let mut positions = HashSet::new();
  let (start_r, start_c) = find_position_of_s(array).unwrap();
  positions.insert((start_r as i64, start_c as i64));

  for _i in 0..steps {
    let mut new_positions = HashSet::new();
    for pos in &positions {
      new_positions.extend(steps_infinity(&array, *pos));
    }
    positions = new_positions;
  }
  positions.len()
}

fn solve2(array: &Vec<Vec<char>>) {
  let mut data: Vec<i64> = vec![];

  let steps: i64 = 26501365;

  let size: i64 = array.len() as i64;
  let half: i64 = steps % size;

    for i in 0..=2 {
    let s = (half + i * size) as usize;
    data.push(calc_plots(&array, s) as i64);
  }
  

  let a: i64 = (data[2] - (2 *data[1]) + data[0]) / 2;
  let b: i64 = data[1] - data[0] - a;
  let c: i64 = data[0];

  let n = (steps - half) / size as i64;
  let res = (a * n * n) + (b * n) + c;

  println!("{:?}", res);
}


fn main() {
  let mut array = parse("input").unwrap();
  solve(&array);   
  solve2(&array);  
}
