#!/usr/bin/env python3
from plumbum import FG
from plumbum import local
from plumbum.cmd import ln
from plumbum.cmd import mkdir


def main():
    mkdir["-p", local.env.home / ".xmonad"] & FG
    ln["-sf", local.cwd / "xmonad.hs", local.env.home / ".xmonad" /
       "xmonad.hs"] & FG
    mkdir["-p", local.env.home / ".config" / "taffybar"] & FG
    mkdir["-p", local.env.home / ".config" / "nvim"] & FG
    ln["-sf", local.cwd / "taffybar.hs", local.env.home / ".config" /
       "taffybar" / "taffybar.hs"] & FG
    ln["-sf", local.cwd / "vimrc", local.env.home / ".vimrc"] & FG
    ln["-sf", local.cwd / "vimrc", local.env.home / ".config" / "nvim" /
       "init.vim"] & FG
    ln["-sf", local.cwd / "bashrc", local.env.home / ".bashrc"] & FG
    ln["-sf", local.cwd / "tmux.conf", local.env.home / ".tmux.conf"] & FG
    ln["-sf", local.cwd / "gitconfig", local.env.home / ".gitconfig"] & FG


if __name__ == '__main__':
    main()
