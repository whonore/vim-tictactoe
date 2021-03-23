if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'tictactoe'

let [s:play1, s:play2] = g:tictactoe#players
let s:play1_hl = get(g:, 'tictactoe#play1_hl', 10)
let s:play2_hl = get(g:, 'tictactoe#play1_hl', 11)

syn clear

execute 'syn match tttPlay1 "\<' . s:play1 . '\>"'
execute 'syn match tttPlay2 "\<' . s:play2 . '\>"'
execute 'syn match tttWin1Msg "Player ' . s:play1 . ' won!"'
execute 'syn match tttWin2Msg "Player ' . s:play2 . ' won!"'
syn match tttCurPlayer 'Current Player:'
syn match tttError 'Error:'
syn region tttInstrKey start=+"+ end=+"+

for s:piece in g:tictactoe#board_pieces
  execute 'syn match tttBoard "' . s:piece . '"'
endfor

execute 'hi def tttPlay1 ctermfg=' . s:play1_hl
execute 'hi def tttPlay2 ctermfg=' . s:play2_hl
execute 'hi def tttWin1Msg ctermfg=' . s:play1_hl
execute 'hi def tttWin2Msg ctermfg=' . s:play2_hl
hi def link tttCurPlayer Label
hi def link tttError Error
hi def link tttInstrKey Keyword
hi def link tttBoard Special
