# A \[R\]ustacean's neo\[V\]im configuration

A fully-featured graphical [neovim] configuration tailor-made for :crab: **Rust** development with support for *autocompletion* and *debugging*.

## Installation

`rv` is packaged as a [flake]. You can run it locally with:

```bash
nix run github:trantorian1/rv
```

> [!TIP]
> For a list of all available keybinds, hit `<Space>sk`

## Configuration

You can extend `rv` with new plugins and configuration options using the [nix module system].

| Option    | Effect                                                       |
| --------- | ------------------------------------------------------------ |
| `plugins` | Appends new plugins and their configurations to `rv`         |
| `shell`   | Sets the default shell in use by `rv`                        |
| `fonts`   | Add custom fonts for use during graphical rendering (using [neovide]) |

Several examples of how to do this can be found in the [examples/] folder

## Testing

`rv` runs a simple integration test against a minimal nixos qemu virtual machine by trying to load its configuration without any errors to make sure all external dependencies are correctly bundled.

```bash
nix flake check
```

## Related projects

- [kickstart.nvim]
- [kickstart-nix.nvim]

[ neovim ]: https://github.com/neovim/neovim
[flake ]:  https://www.tweag.io/blog/2020-05-25-flakes/
[ `default.nix` ]: ./default.nix
[ nix module system]:  https://nix.dev/tutorials/module-system/
[ `options.nix` ]: ./options.nix
[ `config.nix` ]:  ./config.nix
[ neovide ]:  https://github.com/neovide/neovide
[examples/]: ./examples/
[kickstart.nvim]: https://github.com/nix-community/kickstart-nix.nvim
[kickstart-nix.nvim]: https://github.com/nix-community/kickstart-nix.nvim
