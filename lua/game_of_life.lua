generations = 500
height = 50
width = 100

function get_cell(board, row, col)
    if row >= 1 and col >= 1 and row <= board.height and col <= board.width then
        return board.cells[(row*board.width)+col]
    else
        return false
    end
end

function next_generation(board)
    board_copy = {}
    board_copy.height = board.height
    board_copy.width = board.width
    board_copy.cells = {}
    for k,v in pairs(board.cells) do
        board_copy.cells[k] = v
    end

    for i=1,board.height do
        for j=1,board.width do
            cell = get_cell(board_copy, i, j)
            adjacent = 0

            for n=-1,1 do
                for m=-1,1 do
                    if not ((n == -1 and i == 1) or (m == -1 and j == 1) or (n == 0 and m == 0)) then
                        if get_cell(board_copy, i+n, j+m) then
                            adjacent = adjacent + 1
                        end
                    end
                end
            end
                        
            if cell then
                if adjacent < 2 then
                    cell = false
                end
                if adjacent > 3 then
                    cell = false
                end
            else
                if adjacent == 3 then
                    cell = true
                end
            end

            board.cells[(i*board.width)+j] = cell
        end
    end
end

function draw_screen(board)
    for i=1,board.height do
        for j=1,board.width do
            if board.cells[(i*board.width)+j] then
                io.write("██")
            else
                io.write("  ")
            end
        end

        io.write("\n")
    end
end

function run_game(height, width, generations)
    board = {}
    board.height = height
    board.width = width
    board.cells = {}
    for i=1,height*width do
        local trueAndFalse = {true, false}
        board.cells[i] = trueAndFalse[math.random(1, 2)]
    end

    for i=1,generations do
        draw_screen(board)
        io.write(string.char(0x1b) .. "[" .. board.height .. "A")
        next_generation(board)
    end
end

run_game(height, width, generations)