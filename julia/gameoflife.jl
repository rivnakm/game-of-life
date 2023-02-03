generations = 500
height = 50
width = 100

mutable struct Board
    cells::Array{Bool, 1}
    height::Int
    width::Int
end

function getcell(board::Board, row::Int, col::Int)
    if row >= 1 && row <= board.height && col >= 1 && col <= board.width
        return board.cells[((row-1) * board.width) + col]
    else
        return false
    end
end

function nextgeneration(board::Board)::Board
    newboard = Board(zeros(Bool, board.height*board.width), board.height, board.width)
    for i in 1:board.height
        for j in 1:board.width
            cell = getcell(board, i, j)
            adjacent = 0

            for n in -1:1
                for m in -1:1
                    if (n == 0 && m == 0)
                        continue
                    end
                    if getcell(board, i+n, j+m)
                        adjacent += 1
                    end
                end
            end

            if cell
                if adjacent < 2
                    cell = false
                end
                if adjacent > 3
                    cell = false
                end
            else
                if adjacent == 3
                    cell = true
                end
            end

            newboard.cells[((i-1)*board.width)+j] = cell
        end
    end

    return newboard
end

function draw(board::Board)
    for i in 1:board.height
        for j in 1:board.width
            if board.cells[((i-1)*board.width)+j]
                print("██")
            else
                print("  ")
            end
            flush(stdout)
        end
        println()
    end
end     

function rungame(height::Int, width::Int, generations::Int)
    board = Board(rand(Bool, height*width), height, width)

    for _ in 1:generations
        draw(board)
        print("\033[", board.height, "A")
        board = nextgeneration(board)
    end
end

rungame(height, width, generations)