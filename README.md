# A \[R\]ustacean's neo\[V\]im configuration

A fully-featured graphical [neovim] configuration tailor-made for :crab: **Rust** development with support for *autocompletion* and *debugging*.

## Installation

`rv` is packaged into a `nix` derivation which is exposed as a [flake] for convenience. You can run it locally with:

```bash
nix run github:trantorian1/rv
```

> [!TIP]
> For a list of all available keybinds, hit `<Space>sk`

Alternatively, you can configure `rv` by importing it as a derivation from [`default.nix`]

```nix
{
	rv ? import ./default.nix {},
	pkgs ? rv.pkgs,
	...
}: {
	shell = pkgs.mkShellNoCC {
		packages = [ rv.module.config.rv ];
	};
}
```

## Configuration

You can extend `rv` with new plugins and configuration options using the [nix module system].

| Option    | Effect                                                       |
| --------- | ------------------------------------------------------------ |
| `plugins` | Appends new plugins and their configurations to `rv`         |
| `shell`   | Sets the default shell in use by `rv`                        |
| `fonts`   | Add custom fonts for use during graphical rendering (using [neovide]) |

### Plugins

> *A simple example which adds* [lazygit] _to `rv`_.

```nix
# examples/lazygit.nix
{
  rv ? import ./default.nix {},
  pkgs ? rv.pkgs,
  ...
}: let
  module = rv.module.extendModules {
    modules = [
      {
        config.plugins = [
          {
            package = pkgs.vimPlugins.lazygit-nvim;
            config = ./lazygit.lua;
            runtimeDeps = with pkgs; [lazygit];
          }
        ];
      }
    ];
  };
in {
  inherit module;
}
```

And in `examples/lazygit.lua`:

```lua
-- examples/lazygit.lua
if vim.g.did_load_lazygit then
	return
end
vim.g.did_load_lazygit = true

require("lazygit").setup({})
```

Now if you run the following you will produce a new version of `rv` which supports lazygit:

```bash
nix-build examples/lazygit.nix -A module.config.rv && ./result/bin/rv
```

You can check this by calling the `:Lazygit` command.

---

###  Shell

> *Sets the default shell to* `bash`.

```nix
# examples/bash.nix
{
  rv ? import ./default.nix {},
  pkgs ? rv.pkgs,
  ...
}: let
  module = rv.module.extendModules {
    modules = [
      {
        config.shell = pkgs.bash;
      }
    ];
  };
in {
  inherit module;
}
```

Then run:

```bash
nix-build examples/bash.nix -A module.config.rv && ./result/bin/rv
```

---

### Fonts

> *Sets the default graphical font to*  `fira-code`.

```nix
# examples/fira-code.nix
{
  rv ? import ./default.nix {},
  pkgs ? rv.pkgs,
  ...
}: let
  module = rv.module.extendModules {
    modules = [
      {
        config.plugins = [
          {
          	# You can specify plugins without a package and only set config options
            config = ./fira-code.lua;
          }
        ];
        config.fonts = with pkgs; [nerd-fonts.fira-code];
      }
    ];
  };
in {
  inherit module;
}
```

And in  `examples/fira-code.lua`:

```lua
-- examples/fira-code.lua
if vim.g.did_load_fira_code then
	return
end
vim.g.did_load_fira_code = true

vim.o.guifont = "FiraCode Nerd Font:h12"
```

Then run:

```bash
nix-build examples/fira-code.nix -A module.config.rv && ./result/bin/rv
```

## Testing

`rv` runs a simple integration test against a minimal nixos qemu virtual machine by trying to load its configuration without any errors to make sure all external dependencies are being correctly bundled.

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
[ lazygit ]:  https://github.com/jesseduffield/lazygit
[kickstart.nvim]: https://github.com/nix-community/kickstart-nix.nvim
[kickstart-nix.nvim]: https://github.com/nix-community/kickstart-nix.nvim
