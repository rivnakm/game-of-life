type cell = Alive | Dead

let is_alive (adj: int) (c: cell) : cell =
  match (adj, c) with
  | (2, c) -> c
  | (3, _) -> Alive
  | _ -> Dead
;;

let is_in_bounds row col height width =
  row >= 0 && row < height && col >= 0 && col < width
;;

let adjacent_cells r c = [
  (r-1, c-1); (r-1, c); (r-1, c+1);
  (r, c-1); (r, c+1);
  (r+1, c-1); (r+1, c); (r+1, c+1)
]
;;

let get_cell cells height width point = 
  let (r, c) = point in
  if is_in_bounds r c height width then
    cells.(r * width + c)
  else
    Dead
  ;;
;;

let rec read_adjacent cells height width adjs =
  match adjs with
  | [] -> 0
  | x::xs -> match (get_cell cells height width x) with
    | Alive -> 1 + read_adjacent cells height width xs
    | Dead -> 0 + read_adjacent cells height width xs
;;

let get_point width i : (int * int) =
  (i / width, i mod width)
;;

let generate_cell cells height width i =
  let (row, col) = get_point width i in
  let current = cells.(row * width + col) in
  let adjs = adjacent_cells row col in
  let adj = read_adjacent cells height width adjs in
  is_alive adj current
;;

let next_generation (cells: cell array) (height: int) (width: int) : cell array =
  Array.init (height * width) (fun i -> generate_cell cells height width i)
;;

let print_cells cells width = 
  let rec print_cells' cells i = 
    if i = Array.length cells then ()
    else
      let () = if i mod width = 0 then print_endline "" else () in
      let () = match cells.(i) with
        | Alive -> print_string "██"
        | Dead -> print_string "  "
      in
      print_cells' cells (i+1)
  in
  print_cells' cells 0

let rec run cells height width generations =
  print_cells cells width;
  print_string ("\x1b[" ^ (string_of_int height) ^ "A");

  if generations > 0 then
    run (next_generation cells height width) height width (generations - 1)
  else
    ()
  ;;
;;
