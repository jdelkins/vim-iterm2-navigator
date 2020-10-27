let s:dir = expand('<sfile>:p:h:h')

function! iterm2_navigator#install() abort
  if !has('macunix')
    return
  endif
  let l:basedir = s:dir . '/iterm2-scripts'
  let l:appdir = expand('$HOME/Library/Application Support/iTerm2/Scripts')
  call system('mkdir -p ' . shellescape(l:appdir . '/AutoLaunch'))
  call system('ln -sf ' . shellescape(l:basedir . '/force_jump_pane.py') . ' ' . shellescape(l:appdir))
  call system('ln -sf ' . shellescape(l:basedir . '/AutoLaunch/jump_pane.py') . ' ' . shellescape(l:appdir . '/AutoLaunch/'))
endfunction
