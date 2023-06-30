import kotlin.random.Random
import java.io.PrintWriter
import java.io.OutputStreamWriter

const val HEIGHT = 50
const val WIDTH = 100
const val GENS = 500

fun main() {
    val board = Board(HEIGHT, WIDTH)
    val game = Game(board, GENS)
    game.run()
}


class Board(val height: Int, val width: Int) {
    private val cells: Array<BooleanArray> = Array(height) { BooleanArray(width) { Random.nextBoolean() } }


    fun draw(printWriter: PrintWriter) {
        for (row in cells) {
            for (cell in row) {
                printWriter.print(if (cell) "██" else "  ")
            }
            printWriter.println()
        }
        printWriter.flush()
    }

    fun updateCell(row: Int, col: Int, value: Boolean) {
        if (row in 0 until height && col in 0 until width) {
            cells[row][col] = value
        }
    }

    fun isAlive(row: Int, col: Int): Boolean {
        return cells.getOrNull(row)?.getOrNull(col) ?: false
    }
}

class Game(private val board: Board, private val generations: Int) {
    fun run() {
        val printWriter = PrintWriter(OutputStreamWriter(System.out))
        repeat(generations) {
            board.draw(printWriter)
            printWriter.print("\u001b[${board.height}A")
            next()
        }
        printWriter.close()
    }

    private fun next() {
        val updatedCells = Array(board.height) { BooleanArray(board.width) }
        for (i in 0 until board.height) {
            for (j in 0 until board.width) {
                val cell = board.isAlive(i, j)
                val adjacent = countAdjacentAlive(board, i, j)
                val newCell = if (cell) (adjacent in 2..3) else (adjacent == 3)
                updatedCells[i][j] = newCell
            }
        }
        for (i in 0 until board.height) {
            for (j in 0 until board.width) {
                board.updateCell(i, j, updatedCells[i][j])
            }
        }
    }

    private fun countAdjacentAlive(board: Board, row: Int, col: Int): Int {
        var count = 0
        for (i in -1..1) {
            for (j in -1..1) {
                if (i == 0 && j == 0) continue
                val newRow = row + i
                val newCol = col + j
                if (newRow in 0 until board.height && newCol in 0 until board.width && board.isAlive(newRow, newCol)) {
                    count++
                }
            }
        }
        return count
    }
}
