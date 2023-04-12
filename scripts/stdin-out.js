const __readline = require('readline');

const _lines = [];
let _currentLine = 0;

const _rl = __readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

_rl.on('line', line => {
  _lines.push(line);
});

_rl.on('close', () => {
  main();
});

function readln() {
  return _lines[_currentLine++];
}

function write(str) {
  process.stdout.write(str);
}

function writeln(str) {
  process.stdout.write(str + '\n');
}
