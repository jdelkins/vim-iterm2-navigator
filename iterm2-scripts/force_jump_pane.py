#!/usr/bin/env python3.7

import iterm2
import sys
# This script was created with the "basic" environment which does not support adding dependencies
# with pip.

async def main(connection):
    # Your code goes here. Here's a bit of example code that adds a tab to the current window:
    argmap = {
        'h': 'Left',
        'j': 'Below',
        'k': 'Above',
        'l': 'Right',
    }
    menu = 'Select Split Pane.Select Pane {}'.format(argmap[sys.argv[1]])
    try:
        await iterm2.MainMenu.async_select_menu_item(connection, identifier=menu)
    except:
        pass

iterm2.run_until_complete(main)