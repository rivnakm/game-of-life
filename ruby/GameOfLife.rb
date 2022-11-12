require 'io/console'
require 'optparse'

def getCell(cells, row, col, height, width)
    if row >= 0 && col >= 0 && row < height && col < width
        return cells[(row*width)+col]
    else
        return false
    end
end

def nextGeneration(cells, height, width)
    cellsCopy = cells.dup
    
    for i in 0...height do
        for j in 0...width do
            cell = getCell(cellsCopy, i, j, height, width)
            adjacent = 0

            for n in -1..1 do
                for m in -1..1 do
                    if (n == -1 && i == 0) || (m == -1 && j == 0) || (n == 0 && m == 0)
                        next
                    end
                    adjacent += getCell(cellsCopy, i+n, j+m, height, width) ? 1 : 0
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

            cells[i*width+j] = cell
        end
    end
end

def drawScreen(cells, height, width)
    for i in 0...height do
        for j in 0...width do
            if cells[(i*width)+j]
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
    cells = []
    for _ in 0...(height*width) do
        cells.append([true, false].sample)
    end

    if generations == -1
        while true do
            drawScreen(cells, height, width)
            print "\x1b[" + height.to_s + "A"
            STDOUT.flush
            nextGeneration(cells, height, width)
        end
    else
        for i in 0...generations do
            drawScreen(cells, height, width)
            print "\x1b[" + height.to_s + "A"
            STDOUT.flush
            nextGeneration(cells, height, width)
        end
    end
end

options = {}
OptionParser.new do |opts|
    opts.on("-g [GENERATIONS]", "--generations [GENERATIONS]", "Number of generations to run") do |g|
        options[:generations] = g
    end
    opts.on("-s [SIZE]", "--size [SIZE]", "Screen size [WxH]") do |s|
        options[:size] = s
    end
end.parse!


if options[:generations] == nil 
    generations = -1
else
    generations = options[:generations].to_i
end


if options[:size] == nil
    height, width = IO.console.winsize
    height = height - 1
    width = ((width / 2).to_i)
else
    matches = options[:size].match(/^(\d+)x(\d+)/)
    width = matches[1].to_i
    height = matches[2].to_i
end

runGame(height, width, generations)