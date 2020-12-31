" this is used by iterm2, wherein i have a setup that binds cmd-{j,h,k,l} to
" move panes, unles the pane is a vim session, in which case it calls this
" function.

if exists("g:loaded_iterm2_navigator") || &cp || v:version < 700 || !has('python3')
  finish
endif
let g:loaded_iterm2_navigator = 1

py3 <<EOF
import asyncio
try:
  import iterm2
  from iterm2.connection import Connection

  async def force_jump_pane(dir):
      conn = await Connection.async_create()
      argmap = {
          'h': 'Left',
          'j': 'Below',
          'k': 'Above',
          'l': 'Right',
      }
      menu = 'Select Split Pane.Select Pane {}'.format(argmap[dir])
      await iterm2.MainMenu.async_select_menu_item(conn, identifier=menu)
except:
  async def force_jump_pane(_):
    pass
EOF

function! ItermSwitchWindow(key) abort
  let startwindow = winnr()
  exe "wincmd" a:key
  if startwindow == winnr()
    py3 asyncio.ensure_future(force_jump_pane(vim.eval('a:key')))
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
