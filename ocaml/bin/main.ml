open Game

let create_cell c = match c with
  | true -> Alive
  | false -> Dead

let generations = 500
let height = 50
let width = 100
let cells = Array.init (height*width) (fun _ -> create_cell (Random.bool ()))

let () = 
  Random.self_init ();
  Game.run cells height width generations
