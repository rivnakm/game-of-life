import kotlin.random.Random

const val height = 50
const val width = 100
const val gens = 500

fun main() {
    val board = Board(height, width)
    val game = Game(board, gens)
    game.run()
}

class Board(val height: Int, val width: Int) {
    private val cells: MutableList<Boolean> = MutableList(height * width) { Random.nextBoolean() }

    fun getCell(row: Int, col: Int): Boolean {
        return row in 0 until height && col in 0 until width && cells[row * width + col]
    }

    fun setCell(index: Int, value: Boolean) {
        cells[index] = value
    }

    fun draw() {
        for (i in 0 until height) {
            for (j in 0 until width) {
                if (getCell(i, j)) {
                    print("██")
                } else {
                    print("  ")
                }
            }
            println()
        }
    }
}

class Game(private val board: Board, private val generations: Int) {
    fun run() {
        repeat(generations) {
            board.draw()
            print("\u001b[${board.height}A")
            next()
        }
    }

    private fun next() {
        val boardCopy = Board(board.height, board.width)
        for (i in 0 until board.height) {
            for (j in 0 until board.width) {
                var cell = boardCopy.getCell(i, j)
                var adjacent = 0
                for (n in -1..1) {
                    for (m in -1..1) {
                        if (n == 0 && m == 0) {
                            continue
                        }
                        if (boardCopy.getCell(i + n, j + m)) adjacent++
                    }
                }
                if (cell) {
                    if (adjacent < 2 || adjacent > 3) {
                        cell = false
                    }
                } else {
                    if (adjacent == 3) {
                        cell = true
                    }
                }
                board.setCell(i * board.width + j, cell)
            }
        }
    }
}