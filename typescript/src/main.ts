import minimist from 'minimist';
import terminalSize from 'term-size';

import { runGame } from './game.js';

let argv = minimist(process.argv.slice(2));

let iterations = argv.iterations || argv.i;

let height, width;
if (argv.size === undefined && argv.s === undefined) {
    let termSize = terminalSize();
    console.log(`Height: ${termSize.rows}, Width: ${termSize.columns}`);
    height = termSize.rows - 1;
    width = Math.floor(termSize.columns / 2);
    console.log(`Height: ${height}, Width: ${width}`)
}
else {
    let size = argv.size || argv.s;
    let result = size.match(/(\d+)x(\d+)/);
    width = result[1];
    height = result[2];
}

runGame(height, width, iterations);
