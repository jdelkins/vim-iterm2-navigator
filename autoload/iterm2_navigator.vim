function! iterm2_navigator#install() abort
  if !has('macunix')
    return
  endif
  let l:basedir = expand('<sfile>:p:h:h:h') . '/iterm2-scripts'
  let l:appdir = expand('$HOME/Library/Application Support/iTerm2/Scripts')
  call system('mkdir -p ' . shellescape(l:appdir . '/AutoLaunch'))
  call system('ln -sf ' . shellescape(l:basedir . '/force_jump_pane.py') . ' ' . shellescape(l:appdir))
  call system('ln -sf ' . shellescape(l:basedir . '/AutoLaunch/force_jump_pane.py') . ' ' . shellescape(l:appdir . '/AutoLaunch/'))
endfunction
