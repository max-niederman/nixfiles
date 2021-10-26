# Architecture

## `modules`

Contains host-agnostic NixOS and `home-manager` modules.

### `modules/nixos`

NixOS configuration modules. Most applications are installed on a per-user basis, but some applications which either must be installed system-wide or must be usable as `root` are specified here.

### `modules/home`

`home-manager` configuration modules. Most applications are installed here.
