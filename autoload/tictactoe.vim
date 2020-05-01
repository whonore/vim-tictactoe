let g:tictactoe#location = get(g:, 'tictactoe#location', 'aboveleft')
let g:tictactoe#show_controls = get(g:, 'tictactoe#show_controls', 1)

function! s:draw(...) dict abort
  let l:board = self.grid()
  let l:board = map(l:board, '" " . join(v:val, " | ") . " "')
  let l:board = split(join(l:board, "\n" . repeat('-', self.width) . "\n"), '\n')

  let l:winner = self.winner()
  let l:msgs = [
    \ empty(l:winner)
      \ ? 'Current Player: ' . self.players[self.player]
      \ : printf('Player %s won!', l:winner)
  \] + a:000

  let l:controls = [
    \ 'Move the cursor with "h/j/k/l"',
    \ 'Make a move with "<SPACE>"',
    \ 'Restart with "R"'
  \]

  let l:out = l:board + [''] + l:msgs
  if g:tictactoe#show_controls
    let l:out += [''] + l:controls
  endif

  let l:cur = getcurpos()
  setlocal modifiable
  silent %delete
  call setline(1, l:out)
  setlocal nomodifiable
  call setpos('.', l:cur)
endfunction

function! s:islegal(moves, row, col) abort
  for [l:player, l:r, l:c] in a:moves
    if [a:row, a:col] == [l:r, l:c]
      return 0
    endif
  endfor
  return 1
endfunction

function! s:pos_to_grid(pos) dict abort
  let l:row = (min([a:pos[0], self.height]) - 1) / (self.height / 3 + 1)
  let l:col = (min([a:pos[1], self.width]) - 1) / (self.width / 3 + 1)
  return [l:row, l:col]
endfunction

function! s:grid_to_pos(pos) dict abort
  let l:row =
    \ (a:pos[0] >= 0 ? a:pos[0] % 3 : 3 + a:pos[0]) * (self.height / 3 + 1) + 1
  let l:col =
    \ (a:pos[1] >= 0 ? a:pos[1] % 3 : 3 + a:pos[1]) * (self.width / 3 + 1) + 2
  return [l:row, l:col]
endfunction

function! s:move(pos) dict abort
  if !empty(self.winner())
    return
  endif

  let [l:row, l:col] = self.pos_to_grid(a:pos)
  if s:islegal(self.moves, l:row, l:col)
    let self.moves = add(self.moves, [self.players[self.player], l:row, l:col])
    let self.player = (self.player + 1) % len(self.players)
    call self.draw()
  else
    call self.draw('Error: Invalid move.')
  endif
endfunction

function! s:reset() dict abort
  let self.player = 0
  let self.moves = []
  call self.draw()
endfunction

function! s:grid() dict abort
  let l:grid = []
  for l:row in range(3)
    let l:grid = add(l:grid, repeat([' '], 3))
  endfor

  for [l:player, l:row, l:col] in self.moves
    let l:grid[l:row][l:col] = l:player
  endfor
  return l:grid
endfunction

function! s:row(grid, n) abort
  return a:grid[a:n]
endfunction

function! s:col(grid, n) abort
  let l:col = []
  for l:row in a:grid
    let l:col = add(l:col, l:row[a:n])
  endfor
  return l:col
endfunction

function! s:diag(grid, n) abort
  let l:diag = []
  for l:row in range(len(a:grid))
    let l:col = a:n > 0 ? l:row : -(l:row + 1)
    let l:diag = add(l:diag, a:grid[l:row][l:col])
  endfor
  return l:diag
endfunction

function! s:same(xs) abort
  return join(a:xs, '') =~# '^\([^ ]\)\1*$'
endfunction

function! s:winner() dict abort
  let l:grid = self.grid()
  let l:rows = map(range(3), 's:row(l:grid, v:val)')
  let l:cols = map(range(3), 's:col(l:grid, v:val)')
  let l:diags = map([1, -1], 's:diag(l:grid, v:val)')

  for l:line in l:rows + l:cols + l:diags
    if s:same(l:line)
      return l:line[0]
    endif
  endfor
  return ''
endfunction

function! s:setpos(off) dict abort
  let [l:row, l:col] = self.pos_to_grid(getpos('.')[1:2])
  let [l:row, l:col] = self.grid_to_pos([l:row + a:off[0], l:col + a:off[1]])
  call setpos('.', [0, l:row, l:col, 0])
endfunction

function! s:new(mod) abort
  execute a:mod . ' new'
  setfiletype tictactoe
  return {
    \ 'width': 3 * 3 + 2,
    \ 'height': 3 + 2,
    \ 'players': ['x', 'o'],
    \ 'player': 0,
    \ 'moves': [],
    \ 'draw': function('s:draw'),
    \ 'move': function('s:move'),
    \ 'reset': function('s:reset'),
    \ 'pos_to_grid': function('s:pos_to_grid'),
    \ 'grid_to_pos': function('s:grid_to_pos'),
    \ 'grid': function('s:grid'),
    \ 'winner': function('s:winner'),
    \ 'setpos': function('s:setpos')
  \}
endfunction

function! tictactoe#Start(mods) abort
  let l:modpat = escape('\%(above\|below\|top\|bot\|vert\)', '\')
  let l:mod = join(filter(split(a:mods, ' '),
    \ 'v:val =~# "' . l:modpat . '"'), ' ')
  let b:board = s:new(!empty(l:mod) ? l:mod : g:tictactoe#location)
  call b:board.draw()
endfunction
