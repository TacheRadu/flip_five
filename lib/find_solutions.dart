import 'dart:io';
import 'dart:convert';

var dp = <String, int>{};
void flip(List<List<bool>> board, int i, int j) {
  if (i >= 0 && i < board.length && j >= 0 && j < board[i].length) {
    board[i][j] = !board[i][j];
  }
  if (i + 1 >= 0 && i + 1 < board.length && j >= 0 && j < board[i + 1].length) {
    board[i + 1][j] = !board[i + 1][j];
  }
  if (i - 1 >= 0 && i - 1 < board.length && j >= 0 && j < board[i - 1].length) {
    board[i - 1][j] = !board[i - 1][j];
  }
  if (i >= 0 && i < board.length && j + 1 >= 0 && j + 1 < board[i].length) {
    board[i][j + 1] = !board[i][j + 1];
  }
  if (i >= 0 && i < board.length && j - 1 >= 0 && j - 1 < board[i].length) {
    board[i][j - 1] = !board[i][j - 1];
  }
}

void bktr(List<List<bool>> board, int moves) {
  if (dp.containsKey(board.toString()) && dp[board.toString()]! <= moves) {
    return;
  }
  dp[board.toString()] = moves;
  for (var i = 0; i < board.length; i++) {
    for (var j = 0; j < board[i].length; j++) {
      flip(board, i, j);
      bktr(board, moves + 1);
      flip(board, i, j);
    }
  }
}

void main() {
  var board = [
    [false, false, false],
    [false, false, false],
    [false, false, false]
  ];
  bktr(board, 0);
  File('solutions.json').openWrite()
    ..write(jsonEncode(dp))
    ..close();
}
