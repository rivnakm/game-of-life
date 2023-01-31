namespace GameOfLife

open GameOfLife.Board

module Game =
    let inline isAlive cell adjacent =
        match adjacent with
        | 2 -> cell
        | 3 -> true
        | _ -> false

    let inline isInBounds (row:int) (col:int) (width:int) (height:int) : bool =
        row >= 0 && row < height && col >= 0 && col < width

    // get an array of indeces for cells adjacent to the provided cell
    let adjacentCells (row: int) (col: int) : (int * int)list =
        [ row-1, col-1; row, col-1; row+1, col-1; row-1, col; row+1, col; row-1, col+1; row, col+1; row+1, col+1 ]

    let rec readAdjacent (cells:bool[,]) (height:int) (width:int) (adjacents:(int * int)list) : int =
        match adjacents with
        | [] -> 0
        | (row,col)::tail ->
            let cell = if isInBounds row col width height && cells[row, col] then 1 else 0 
            cell + readAdjacent cells height width tail

    let nextGeneration (board:Board) : Board = 
        let newCells = Array2D.init board.height board.width (fun row col ->
            adjacentCells row col
            |> readAdjacent board.cells board.height board.width
            |> isAlive board.cells[row, col])

        new Board(board.height, board.width, newCells)

    let rec drawCell (grid:bool[,]) (row:int) (col:int) (width:int) =
        match grid.[row, col] with
        | true -> printf "██"
        | false -> printf "  "

        if col+1 < width then
            drawCell grid row (col+1) width
        else
            ()

    let rec drawRow (grid:bool[,]) (row:int) (height:int) (width:int) =
        drawCell grid row 0 width
        printfn ""
        
        if row+1 < height then
            drawRow grid (row+1) height width
        else
            ()

    let drawScreen (board:Board) =
        drawRow board.cells 0 board.height board.width

    let rec run (board:Board) (generations:int) =
        drawScreen board
        printf $"\x1b[{board.height}A"

        match generations with
        | 0 -> ()
        | _ ->
            let boardNew = nextGeneration board
            run boardNew (generations - 1)