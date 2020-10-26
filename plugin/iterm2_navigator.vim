" this is used by iterm2, wherein i have a setup that binds cmd-{j,h,k,l} to
" move panes, unles the pane is a vim session, in which case it calls this
" function.

if exists("g:loaded_iterm2_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_iterm2_navigator = 1

function! ItermSwitchWindow(key) abort
  let startwindow = winnr()
  exe "wincmd" a:key
  if startwindow == winnr()
    call system('osascript -e ' . shellescape('tell application "iTerm" to launch API script named "force_jump_pane.py" arguments ["' . a:key . '"]'))
  endif
endfunction

function! s:do_iterm_maps(mode_cmd, map_template)
  exe a:mode_cmd '<silent> <C-_>h' printf(a:map_template, 'h')
  exe a:mode_cmd '<silent> <C-_>j' printf(a:map_template, 'j')
  exe a:mode_cmd '<silent> <C-_>k' printf(a:map_template, 'k')
  exe a:mode_cmd '<silent> <C-_>l' printf(a:map_template, 'l')
endfunction

call s:do_iterm_maps('noremap', ':<C-U>call ItermSwitchWindow("%s")<CR>')
call s:do_iterm_maps('tnoremap', '<C-\><C-N>:<C-U>call ItermSwitchWindow("%s")<CR>')
call s:do_iterm_maps('inoremap', '<C-O>:call ItermSwitchWindow("%s")<CR>')
call s:do_iterm_maps('cnoremap', '<C-U>call ItermSwitchWindow("%s")<CR>')
