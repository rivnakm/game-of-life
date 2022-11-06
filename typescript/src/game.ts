import ansiEscapes from 'ansi-escapes';

export function runGame(height: number, width: number, iterations: number) {
    let cells: Array<boolean> = [];
    for (let i = 0; i < height * width; i++) {
        cells.push(Math.random() < 0.5);
    }

    if (iterations === undefined) {
        while (true) {
            drawScreen(cells, height, width);
            process.stdout.write(ansiEscapes.cursorUp(height));
            nextGen(cells, height, width);
        }
    } else {
        for (let i = 0; i < iterations; i++) {
            drawScreen(cells, height, width);
            process.stdout.write(ansiEscapes.cursorUp(height));
            nextGen(cells, height, width);
        }
    }
}

function drawScreen(cells: Array<boolean>, height: number, width: number) {
    for (let i = 0; i < height; i++) {
        for (let j = 0; j < width; j++) {
            if (cells[(i * width) + j]) {
                process.stdout.write("██");
            } else {
                process.stdout.write('  ');
            }
        }
        process.stdout.write("\n");
    }
}

function getCell(
    cells: Array<boolean>,
    row: number,
    col: number,
    height: number,
    width: number,
): boolean {
    if (row >= 0 && col >= 0 && row < height && col < width) {
        return cells[row * width + col];
    } else {
        return false;
    }
}

function nextGen(cells: Array<boolean>, height: number, width: number) {
    const cellsCopy = Object.assign([], cells);

    for (let i = 0; i < height; i++) {
        for (let j = 0; j < width; j++) {
            let cell = getCell(cellsCopy, i, j, height, width);
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
                    adjacent += Number(
                        getCell(cellsCopy, i + n, j + m, height, width),
                    );
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

            cells[i * width + j] = cell;
        }
    }
}
