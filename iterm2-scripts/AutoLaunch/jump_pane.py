#!/usr/bin/env python3

import asyncio
import iterm2
import re

# To be assigned to an iTerm2 keymap using the "Invoke Script Function..."
# action. The invoked script should be as follows:
#       do_jump(session_id: id, direction: "j")
# where the `direction` parameter should be one of "h", "j", "k", or "l"

async def main(connection):
    app = await iterm2.async_get_app(connection)

    @iterm2.RPC
    async def do_jump(session_id, direction):
        sess = app.get_session_by_id(session_id)
        title = await sess.async_get_variable('terminalWindowName')
        if title is None:
            title = ''

        # first choice: if inside vim, send a special keystroke to navigate
        # vim windows (requires special vim configuration)
        if re.match(r'.* - N?VIM$', title):
            await sess.async_send_text(f'{direction}', suppress_broadcast=True)
            return

        # second choice: send tmux window-control sequences if we have an
        # attached session. Requires configuration to set window title. In my
        # case, this is done in ~/.zshrc
        if re.match(r'.* - TMUX@[\w-]+$', title):
            argmap = {
                'h': 'p',
                'l': 'n',
            }
            try:
                await sess.async_send_text(argmap[direction])
                return
            except KeyError:
                pass

        # by default, navigate iTerm panes
        argmap = {
            'h': 'Left',
            'j': 'Below',
            'k': 'Above',
            'l': 'Right',
        }
        menu = f'Select Split Pane.Select Pane {argmap[direction]}'
        try:
            await iterm2.MainMenu.async_select_menu_item(connection, identifier=menu)
        except:
            pass

    await do_jump.async_register(connection)

iterm2.run_forever(main)
