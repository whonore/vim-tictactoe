if exists('g:loaded_tictactoe')
  finish
endif
let g:loaded_tictactoe = 1

command! -bang TicTacToe call tictactoe#Start(<q-mods>, <bang>0)
