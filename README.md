iTerm2 Navigator
================

This plugin is a port of [Chris Toomey's
vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
plugin. Credit is also due to [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator).

When combined with a set of [iTerm2](https://iterm2.com) key bindings and
scripts, as well as vim's `title` option, the plugin will allow you to
navigate seamlessly between vim and iTerm2 window splits using a consistent set of
hotkeys.

**NOTE 1**: This requires iTerm2 v3.3 or higher, in order to support the
[python API](https://www.iterm2.com/python-api/).

**NOTE 2**: This requires `python3` feature, which, on [neovim][], involves only
installing python3 and [pynvim](https://pypi.org/project/pynvim/). Developed
and used on [neovim][]. Untested on [vanilla vim](https://www.vim.org/) (I'd
actually be a bit surprised if it worked).

[neovim]: https://neovim.io

**NOTE 3**: This plugin is quite hacky, and as such assumes you know basic unix
shell skills, like how to make symbolic links and so on. If you are not at that
level, this plugin will prove frustrating.

Usage
-----

This plugin provides the following mappings which allow you to move between
Vim panes and iTerm2 splits seamlessly.

- `<cmd-h>` → Left
- `<cmd-j>` → Down
- `<cmd-k>` → Up
- `<cmd-l>` → Right

Installation
------------

As this software is an integration between iTerm and vim, it will require
some configuration in both software packages.

### Vim

If you don't have a preferred installation method, I recommend using
[vim-plug](https://github.com/junegunn/vim-plug).  Asuming you have vim-plug
installed and configured, the following steps will install the plugin:

Add the following line to your `~/.vimrc` or `~/.config/nvim/init.vim` file.

```viml
Plug 'jdelkins/vim-iterm2-navigator', {'branch': 'main', 'do': {-> iterm2_navigator#install()}}
set title
```

Then run

```viml
:PlugInstall
```

### iTerm2

This is the trickiest part, requiring a number of steps to set up.

**1. Symlink the scripts for iTerm2**

The `iterm2_navigator#install()` function should handle this part for you (on
macOS, the only platform where iTerm2 is available), but in case you want to
manually install, follow this general procedure.

<pre lang="bash">
<code>$ mkdir -p "~/Library/Application Support/iTerm2/Scripts/AutoLaunch"
$ ln -s <i><b>«vimdir»</b></i>/bundle/vim-iterm2-navigator/iterm2-scripts/AutoLaunch/jump_pane.py "~/Library/Application Support/iTerm2/Scripts/AutoLaunch/"
</code></pre>

**2. Enable iTerm2 python API** (this will involve downloading the python runtime).

  - Enable the following setting:<br/><br/>`Preferences`→`General`→`Magic`→`Enable Python API`

  - Restart iTerm2 or else ensure that the `jump_pane.py` script is running

**3. Create Key Bindings**

  - Under `Preferences`→`Keys`→`Key Bindings`, Click `+` to create a new key binding
  - For shortcut key, enter `⌘h`
  - For `Action`, choose `Invoke Script Function...`
  - In the `function call` box, enter: `do_jump(session_id: id, direction: "h")`

Repeat the above (#3) procedure, replacing `h` with `j`, `k`, and `l`.
The end result should be four key bindings, each calling the `do_jump`
RPC coroutine respectively with parameters of `h`, `j`, `k`, and `l`.

**Note:** You can use any key combination instead of `⌘h` etc. Vim will
never see these keystrokes, as they will be captured by iTerm2, and the
python script will translate them to intermediate keystrokes to trigger the
Vim maps defined in the plugin. These intermediate maps are designed to be
(hopefully) distinct.

**Advanced info**: These intermediate keystrokes are `<C-_>{h,j,k,l}`. If
you want to change them (presumably due to a conflict with another map
you are using), then you'll have to edit the python and vim scripts.

### Vim configuration
    
`vim-iterm2-navigator` uses the window title to detect when it is in a (neo)vim
session or not. You must therefore enable the `title` setting, which is not
on by default:

```viml
set title
```

The default `titlestring` ends with either `- VIM` or `- NVIM` for vim or
neovim, respectively. The python scripts rely on this pattern to determine
whether vim is running in the window. If you have a non-standard `titlestring`
set for vim, for this plugin to work, it must also end with one of these
strings. For example:

```viml
let &titlestring='%t - NVIM'
```

License
-------

This project is licensed under [the same terms as Vim itself](https://github.com/vim/vim/blob/master/LICENSE).

Copyright (c) Joel D. Elkins <joel@elkins.co>. All rights reserved.
