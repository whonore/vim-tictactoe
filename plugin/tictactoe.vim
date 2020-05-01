if exists('g:loaded_tictactoe')
  finish
endif
let g:loaded_tictactoe = 1

command! TicTacToe call tictactoe#Start(<q-mods>)
