if exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'tictactoe'

let [s:play1, s:play2] = g:tictactoe#players

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

hi def tttPlay1 ctermfg=10
hi def tttPlay2 ctermfg=11
hi def tttWin1Msg ctermfg=10
hi def tttWin2Msg ctermfg=11
hi def link tttCurPlayer Label
hi def link tttError Error
hi def link tttInstrKey Keyword
hi def link tttBoard Special
