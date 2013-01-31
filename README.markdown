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

