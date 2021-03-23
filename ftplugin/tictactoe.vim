" Only source once.
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal nomodifiable
setlocal buftype=nofile
setlocal noswapfile
setlocal bufhidden=hide

nnoremap <buffer> <silent> ?
  \ :let b:tictactoe_help = !get(b:, 'tictactoe_help', g:tictactoe#help)
  \ <bar> call b:board.draw()<CR>
nnoremap <buffer> <silent> <SPACE> :call b:board.move(getpos('.')[1:2])<CR>
nmap <buffer> <silent> <RETURN> <SPACE>
nnoremap <buffer> <silent> R :call b:board.reset()<CR>
nmap <buffer> <silent> r R
nnoremap <buffer> <silent> h :call b:board.setpos([0, -1])<CR>
nnoremap <buffer> <silent> l :call b:board.setpos([0, 1])<CR>
nnoremap <buffer> <silent> j :call b:board.setpos([1, 0])<CR>
nnoremap <buffer> <silent> k :call b:board.setpos([-1, 0])<CR>
nmap <buffer> <silent> <Left> h
nmap <buffer> <silent> <Right> l
nmap <buffer> <silent> <Down> j
nmap <buffer> <silent> <Up> k
nnoremap <buffer> <silent> Q :quit<CR>
nmap <buffer> <silent> q Q

" Snap cursor to grid
augroup tictactoe
  autocmd!
  autocmd CursorMoved <buffer> call b:board.setpos([0, 0])
augroup END
