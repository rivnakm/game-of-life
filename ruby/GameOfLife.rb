class Board
    def initialize(height, width, cells = nil)
        if cells == nil
            @_cells = []
            for _ in 0...(height*width) do
                @_cells.append([true, false].sample)
            end
        else
            @_cells = cells
        end

        @_height = height
        @_width = width
    end

    def height
        @_height
    end

    def width
        @_width
    end

    def cells
        @_cells
    end

    def copy()
        return Board.new(@_height, @_width, @_cells.dup)
    end
end

def getCell(board, row, col)
    if row >= 0 && col >= 0 && row < board.height && col < board.width
        return board.cells[(row*board.width)+col]
    else
        return false
    end
end

def nextGeneration(board)
    boardCopy = board.copy()
    
    for i in 0...board.height do
        for j in 0...board.width do
            cell = getCell(boardCopy, i, j)
            adjacent = 0

            for n in -1..1 do
                for m in -1..1 do
                    if (n == 0 && m == 0)
                        next
                    end
                    if getCell(boardCopy, i+n, j+m)
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

            board.cells[(i*board.width)+j] = cell
        end
    end
end

def drawScreen(board)
    for i in 0...board.height do
        for j in 0...board.width do
            if board.cells[(i*board.width)+j]
                print "██"
            else
                print "  "
            end
        end

        print "\n"
    end
    STDOUT.flush
end

def runGame(height, width, generations)
    board = Board.new(height, width)

    for i in 0...generations do
        drawScreen(board)
        print "\x1b[" + board.height.to_s + "A"
        STDOUT.flush
        nextGeneration(board)
    end
end

generations = 500
height = 50
width = 100

runGame(height, width, generations)