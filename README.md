Dotfiles
========

Configuration files for various utilities that I regularly use. 

Usage
-----

Running `usesh/use` will download a version of [GNU Stow][] for use, if one is not already installed.

Use the executable `./use` instead of `./stow`:

```sh
usesh/use git vim zsh fish
```

`use` will store all `use`d directories, so afterwards synchronizing is done via:

```sh
usesh/use
```

Requirements
------------

- [GNU Stow][]

**OR**

- Perl 5
- `wget`
- `make`

[GNU Stow]: https://www.gnu.org/software/stow/
