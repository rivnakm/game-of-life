import ansiEscapes from 'ansi-escapes';

class Board {
    cells: Array<boolean>;
    swap: Array<boolean>;
    height: number;
    width: number;

    constructor(height: number, width: number, cells: Array<boolean> = null) {
        let total: number = height * width;
        if (cells === null) {
            let _cells: Array<boolean> = new Array(total);
            for (let i = 0; i < total; ++i) {
                _cells[i] = Math.random() < 0.5;
            }
            this.cells = _cells;
        } else {
            this.cells = cells;
        }
        this.swap = new Array(total);
        this.height = height;
        this.width = width;
    }

    copy(): Board {
        return new Board(
            this.height,
            this.width,
            Object.assign([], this.cells),
        );
    }
}

export function runGame(height: number, width: number, generations: number) {
    let board = new Board(height, width);

    for (let i = 0; i < generations; ++i) {
        drawScreen(board);
        process.stdout.write(ansiEscapes.cursorUp(board.height));
        nextGen(board);
    }
}

function drawScreen(board: Board) {
    for (let i = 0; i < board.height; ++i) {
        for (let j = 0; j < board.width; ++j) {
            if (board.cells[i * board.width + j]) {
                process.stdout.write('██');
            } else {
                process.stdout.write('  ');
            }
        }
        process.stdout.write('\n');
    }
}

function getCell(board: Board, row: number, col: number): boolean {
    return (
        row >= 0 &&
        col >= 0 &&
        row < board.height &&
        col < board.width &&
        board.cells[row * board.width + col]
    );
}

function nextGen(board: Board) {
    for (let i = 0; i < board.height; ++i) {
        for (let j = 0; j < board.width; ++j) {
            let adjacent = 0;

            for (let n = -1; n <= 1; ++n) {
                for (let m = -1; m <= 1; ++m) {
                    if (n == 0 && m == 0) {
                        continue;
                    }
                    if (getCell(board, i + n, j + m)) {
                        ++adjacent;
                    }
                }
            }

            const cell = getCell(board, i, j);

            board.swap[i * board.width + j] =
                adjacent == 3 || (cell && adjacent == 2);
        }
    }
    const tmp = board.cells;
    board.cells = board.swap;
    board.swap = tmp;
}
