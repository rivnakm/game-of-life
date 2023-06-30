import java.io.BufferedWriter
import kotlin.random.Random
import java.io.OutputStreamWriter

const val HEIGHT = 50
const val WIDTH = 100
const val GENS = 500

fun main() {
    runGame(HEIGHT, WIDTH, GENS)
}

class Board(val height: Int, val width: Int) {
    private var cells: BooleanArray = BooleanArray(height * width)
    private var swap: BooleanArray = BooleanArray(height * width)

    init {
        for (i in 0 until height * width) {
            cells[i] = Random.nextFloat() > 0.5
        }
    }

    fun getCell(row: Int, col: Int): Boolean {
        return cells[row * width + col]
    }

    fun setCell(row: Int, col: Int, value: Boolean) {
        swap[row * width + col] = value
    }

    fun swapBuffers() {
        val temp = cells
        cells = swap
        swap = temp
    }
}

fun runGame(height: Int, width: Int, generations: Int) {
    val board = Board(height, width)
    val clear = "\u001b[${board.height}A"
    val writer = BufferedWriter(OutputStreamWriter(System.out, Charsets.UTF_8), (height * width * 6) + height + clear.length)

    for (i in 0 until generations) {
        writer.write(clear)
        drawScreen(writer, board)
        writer.flush()
        nextGen(board)
    }
    writer.close()
}

fun nextGen(board: Board) {
    for (i in 0 until board.height) {
        for (j in 0 until board.width) {
            val cell = board.getCell(i, j)
            val adjacent = countAdjacentAlive(board, i, j)
            val newCell = if (cell) (adjacent in 2..3) else (adjacent == 3)
            board.setCell(i, j, newCell)
        }
    }
    board.swapBuffers()
}

fun countAdjacentAlive(board: Board, row: Int, col: Int): Int {
    var count = 0
    for (n in -1..1) {
        for (m in -1..1) {
            if (n == 0 && m == 0) {
                continue
            }
            if (isValidCoordinate(board, row + n, col + m) && board.getCell(row + n, col + m)) {
                count++
            }
        }
    }
    return count
}

fun isValidCoordinate(board: Board, row: Int, col: Int): Boolean {
    return row in 0 until board.height && col in 0 until board.width
}

fun drawScreen(writer: BufferedWriter, board: Board) {
    for (i in 0 until board.height) {
        for (j in 0 until board.width) {
            if (board.getCell(i, j)) {
                writer.write("██")
            } else {
                writer.write("  ")
            }
        }
        writer.write("\n")
    }
}