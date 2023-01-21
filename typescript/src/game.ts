import ansiEscapes from 'ansi-escapes';

class Board {
    cells: Array<boolean>;
    height: number;
    width: number;

    constructor(height: number, width: number, cells: Array<boolean> = null) {
        if (cells === null) {
            let _cells: Array<boolean> = [];
            for (let i = 0; i < height * width; i++) {
                _cells.push(Math.random() < 0.5);
            }
            this.cells = _cells;
        } else {
            this.cells = cells;
        }
        this.height = height;
        this.width = width;
    }

    copy(): Board {
        return new Board(this.height, this.width, Object.assign([], this.cells));
    }
}

export function runGame(height: number, width: number, generations: number) {
    let board = new Board(height, width);

    for (let i = 0; i < generations; i++) {
        drawScreen(board);
        process.stdout.write(ansiEscapes.cursorUp(board.height));
        nextGen(board);
    }
}

function drawScreen(board: Board) {
    for (let i = 0; i < board.height; i++) {
        for (let j = 0; j < board.width; j++) {
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
    if (row >= 0 && col >= 0 && row < board.height && col < board.width) {
        return board.cells[row * board.width + col];
    } else {
        return false;
    }
}

function nextGen(board: Board) {
    const boardCopy = board.copy();

    for (let i = 0; i < board.height; i++) {
        for (let j = 0; j < board.width; j++) {
            let cell = getCell(boardCopy, i, j);
            let adjacent = 0;

            for (let n = -1; n <= 1; n++) {
                for (let m = -1; m <= 1; m++) {
                    if (
                        (n === -1 && i === 0) ||
                        (m === -1 && j === 0) ||
                        (n === 0 && m === 0)
                    ) {
                        continue;
                    }
                    if (getCell(boardCopy, i + n, j + m)) {
                        adjacent++;
                    }
                }
            }

            if (cell) {
                if (adjacent < 2) {
                    cell = false;
                }
                if (adjacent > 3) {
                    cell = false;
                }
            } else {
                if (adjacent === 3) {
                    cell = true;
                }
            }

            board.cells[i * board.width + j] = cell;
        }
    }
}
