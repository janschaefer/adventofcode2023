
let read_first_line_and_split filename =
  let ic = open_in filename in
  try
    let line = input_line ic in
    close_in ic;
    String.split_on_char ',' line
  with End_of_file ->
    close_in ic;
    [] 

let calculate_char_value acc c =
  let ascii_code = Char.code c in
  let res = (17 * (acc + ascii_code)) mod 256 in
  res  

let calculate_hash str =
  String.to_seq str |> Seq.fold_left calculate_char_value 0

let print_lenses lenses = 
  Printf.printf "[ "; List.iter (fun (a, b) -> Printf.printf "(%s, %d) " a b) lenses;   Printf.printf "] "

let remove_lense label boxes =
  let hash = calculate_hash label in
  let lenses = List.filter (fun (l, _) -> label <> l) (Array.get boxes hash) in
  Array.set boxes hash lenses;
  boxes

let rec add_or_replace_lense label focus_power lenses =
  match lenses with
  | [] -> [(label, focus_power)]
  | (l, f) :: xs -> 
    if l = label then
      (label, focus_power) :: xs
    else
      (l, f) :: add_or_replace_lense label focus_power xs

let add_lense label focus_power boxes =
  let hash = calculate_hash label in
  let lenses = add_or_replace_lense label focus_power (Array.get boxes hash) in
  Array.set boxes hash lenses;
  boxes

let _print_array boxes =
  Array.iter (fun lst -> print_lenses lst) boxes;
  Printf.printf "\n"

let apply_step boxes step =
  let last_char = String.get step ((String.length step) - 1) in
  match last_char with
  | '-' -> (let splitted = String.split_on_char '-' step in 
    match splitted with
    | label :: _ -> remove_lense label boxes
    | _ -> boxes)
  | _ -> let splitted = String.split_on_char '=' step in
      match splitted with
      | label :: [focus_value] -> add_lense label (int_of_string focus_value) boxes
      | _ -> boxes

let calc_focus_value_for_lense box_i i (_, focus_power) = 
  (box_i + 1) * (i+1) * focus_power

let calculate_focus_power box_i (lenses : (string * int) list) =
  List.mapi (calc_focus_value_for_lense box_i) lenses
    |> List.fold_left (fun acc x -> acc + x) 0

let solve filename =
  let splitted_list = read_first_line_and_split filename in
  let result = List.fold_left (fun acc str -> acc + (calculate_hash str)) 0 splitted_list in
  Printf.printf "\n%d\n" result

let solve2 filename =
  let splitted_list = read_first_line_and_split filename in
  let boxes = List.fold_left apply_step (Array.make 256 []) splitted_list in
  let result = Array.mapi calculate_focus_power boxes
    |> Array.fold_left (fun acc focus_power -> acc + focus_power) 0 in
  Printf.printf "\n%d\n" result
  
let () =
  let filename = "input" in
  solve filename;
  solve2 filename;

