This is a heavily altered version of [sontek](http://github.com/sontek)'s dotfiles
### Instructions
Any file which matches the shell glob `_*` will be linked into `$HOME` as a symlink with the first `_`  replaced with a `.`

For example:

    _bashrc

becomes

    ${HOME}/.bashrc

### Installing source files

    ./install.sh

### Restore old source Files
To replace installed files with the originals:

    ./install.sh restore

### Notes

0. I install xmonad from the distros repo and login via the login screen, but you could definitely cabal install xmonad also.
1. if xmonad fails because of X11 dependency just `cabal install X11`  Might also need to `apt-get install libx11-dev`
  - if that fails, you probably need libxrandr-dev
2. disable capslock with `setxkbmap -option ctrl:nocaps`
3. can use arandr to make a script for display configuration (in the case of dual displays)
4. remember to add $HOME/bin to the path (PATH=$PATH:$HOME/bin)
5. dmenu is a dependency for xmonad mod-p.  just apt-get it (suckless-tools)
