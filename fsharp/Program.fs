open System
open GameOfLife.Board
open GameOfLife.Game

[<EntryPoint>]
let main argv =
    printfn "Hello World!"
    let generations = 500
    let height = 50
    let width = 100

    let random = Random()
    let cells = Array2D.init height width (fun x y -> random.Next(2) = 1)
    let board = new Board(height, width, cells)

    run board generations

    0 // return an integer exit code