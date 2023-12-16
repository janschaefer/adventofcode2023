use strict;
use warnings;
use feature 'switch';

no warnings 'recursion';  
no warnings 'experimental';

sub parse_file_to_2d_array {
    my ($filename) = @_;
    my @data;

    open(my $fh, '<', $filename) or die "Cannot open file $filename";
    while (my $line = <$fh>) {
        chomp $line;
        push @data, [split //, $line];
    }
    close($fh);

    return \@data;
}

sub print_2d_array {
    my ($array_ref) = @_;
    foreach my $row (@$array_ref) {
        foreach my $elem (@$row) {
            print $elem;
        }
        print "\n";
    }
}

sub create_zero_filled_2d_array {
    my ($array_ref) = @_;
    my @zero_array;

    for my $row (@$array_ref) {
        push @zero_array, [(0) x scalar @$row];
    }

    return \@zero_array;
}

sub count_ones_in_2d_array {
    my ($array_ref) = @_;
    my $count = 0;

    foreach my $row (@$array_ref) {
        foreach my $elem (@$row) {
            $count++ if $elem == 1;
        }
    }

    return $count;
}

sub apply_dir {
  my ($pos, $dir) = @_;
  my ($row, $col) = @$pos;
  my ($row_dir, $col_dir) = @$dir;

  return [$row + $row_dir, $col + $col_dir];
}

sub run_beam_c {
  my ($cache, $array_ref, $energized_array, $pos, $dir) = @_;
  my ($row, $col) = @$pos;
  my ($row_dir, $col_dir) = @$dir;

  my $key = $row . ',' . $col . ',' . $row_dir . ',' . $col_dir;
  
  if (exists $cache->{$key}) {
    return;
  }

  $cache->{$key} = 1;
  run_beam($cache, $array_ref, $energized_array, $pos, $dir);
}

sub run_beam {
  my ($cache, $array_ref, $energized_array, $pos, $dir) = @_;
  
  my ($row, $col) = @$pos;

  if ($row < 0 || $row >= @$array_ref || $col < 0 || $col >= @{$array_ref->[$row]}) {
    return;
  }

  my $value = $array_ref->[$row][$col];

  $energized_array->[$row][$col] = 1;

  my ($row_dir, $col_dir) = @$dir;

  given ($value) {
    when (".") { 
      run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $dir), $dir);
    }
    when ("/") { 
      my $newDir = [-$col_dir, -$row_dir]; 
      run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir), $newDir);
    }
    when ("\\") { 
      my $newDir = [$col_dir, $row_dir]; 
      run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir), $newDir);
    }
    when ("-") { 
      if ($row_dir == 0) {
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $dir), $dir);
      } else {
        my $newDir = [$col_dir, $row_dir]; 
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir), $newDir);
        my $newDir2 = [$col_dir, -$row_dir]; 
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir2), $newDir2);
      }
    }
    when ("|") { 
      if ($col_dir == 0) {
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $dir), $dir);
      } else {
        my $newDir = [$col_dir, $row_dir]; 
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir), $newDir);
        my $newDir2 = [-$col_dir, $row_dir]; 
        run_beam_c($cache, $array_ref, $energized_array, apply_dir($pos, $newDir2), $newDir2);
      }
    }
  }
  
}

sub calc_energized_cells {
  my ($array_ref, $start_pos, $start_dir) = @_;

  my $energized_array = create_zero_filled_2d_array($array_ref);
  run_beam({}, $array_ref, $energized_array, $start_pos, $start_dir);
  my $energized_cells = count_ones_in_2d_array($energized_array);
}

sub solve {
  my ($filename) = @_;
  my $array_ref = parse_file_to_2d_array($filename);

  my $energized_cells = calc_energized_cells($array_ref, [0,0], [0,1]);
  print $energized_cells . "\n";
}

sub solve2 {
  my ($filename) = @_;
  my $array_ref = parse_file_to_2d_array($filename);

  my $best_value = 0;

  my $last_col = @{$array_ref->[0]};
  my $last_row = @$array_ref;
  
  for (my $col = 0; $col < $last_col; $col++) {
    my $energized_cells = calc_energized_cells($array_ref, [0,$col], [1,0]);
    if ($energized_cells > $best_value) {
      $best_value = $energized_cells;
    }

    $energized_cells = calc_energized_cells($array_ref, [$last_row - 1,$col], [-1,0]);
    if ($energized_cells > $best_value) {
      $best_value = $energized_cells;
    }
  }

  for (my $row = 0; $row < $last_row; $row++) {
    my $energized_cells = calc_energized_cells($array_ref, [$row,0], [0,1]);
    if ($energized_cells > $best_value) {
      $best_value = $energized_cells;
    }

    $energized_cells = calc_energized_cells($array_ref, [$row, $last_col - 1], [0,-1]);
    if ($energized_cells > $best_value) {
      $best_value = $energized_cells;
    }
  }

  print $best_value . "\n";
}

my $filename = 'input';  
solve($filename);
solve2($filename);
