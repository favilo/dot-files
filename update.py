#!/usr/bin/env python
from plumbum import FG
from plumbum import local
from plumbum.cmd import ln
from plumbum.cmd import mkdir

def main():
  mkdir["-p", local.env.home / ".xmonad"] & FG
  ln["-sf", local.cwd / "xmonad.hs", 
     local.env.home / ".xmonad" / "xmonad.hs"] & FG
  mkdir["-p", local.env.home / ".config" / "taffybar"] & FG
  ln["-sf", local.cwd / "taffybar.hs",
     local.env.home / ".config" / "taffybar" / "taffybar.hs"] & FG
  ln["-sf", local.cwd / "vimrc", 
     local.env.home / ".vimrc"] & FG


if __name__ == '__main__':
  main()
