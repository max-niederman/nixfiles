# Architecture

## `modules`

Contains host-agnostic NixOS and `home-manager` modules.

Modules are generally very opinionated, but `enable` options are usually provided. `enable` option default are generally set in the nearest large module's `default.nix`.

### `modules/nixos`

NixOS configuration modules. Most applications are installed on a per-user basis, but some applications which either must be installed system-wide or must be usable as `root` are specified here.

### `modules/home`

`home-manager` configuration modules. Most applications are installed here.
