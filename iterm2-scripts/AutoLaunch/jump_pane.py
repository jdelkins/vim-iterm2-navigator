#!/usr/bin/env python3

import asyncio
import iterm2
import re

# This script was created with the "basic" environment which does not support adding dependencies
# with pip.

async def main(connection):
    app = await iterm2.async_get_app(connection)

    @iterm2.RPC
    async def do_jump(session_id, direction):
        sess = app.get_session_by_id(session_id)
        title = await sess.async_get_variable('terminalWindowName')
        if re.match(r'.* - N?VIM$', title):
            await sess.async_send_text(f'{direction}', suppress_broadcast=True)
        else:
            argmap = {
                'h': 'Left',
                'j': 'Below',
                'k': 'Above',
                'l': 'Right',
            }
            menu = 'Select Split Pane.Select Pane {}'.format(argmap[direction])
            try:
                await iterm2.MainMenu.async_select_menu_item(connection, identifier=menu)
            except:
                pass

    await do_jump.async_register(connection)

iterm2.run_forever(main)
