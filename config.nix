{
  config,
  pkgs,
  lib,
  rustRelease,
  ...
}: let
  basePlugins = with pkgs.vimPlugins; [
    plenary-nvim
    nvim-web-devicons
    nui-nvim
    snacks-nvim

    (nvim-treesitter.withPlugins (
      plugins:
        with plugins; [
          nix
          lua
          rust
          json
          yaml
          toml
          c
        ]
    ))

    telescope-nvim
    telescope-ui-select-nvim
    telescope-fzf-native-nvim

    git-blame-nvim
    diffview-nvim
    gitsigns-nvim
    oil-git-nvim

    fidget-nvim
    nvim-lspconfig
    rustaceanvim

    oil-nvim
    nvim-autopairs
    blink-cmp
    luasnip
    conform-nvim
    todo-comments-nvim
    comment-nvim
    flash-nvim
    vim-visual-multi
    neogen
    nvim-treesitter-context

    catppuccin-nvim
    auto-dark-mode-nvim
    bufferline-nvim
    colorful-winsep-nvim
    helpview-nvim
    lualine-nvim
    render-markdown-nvim
    noice-nvim
    precognition-nvim
    rainbow-delimiters-nvim
    nvim-scrollbar
    edgy-nvim
    which-key-nvim
    smart-splits-nvim
    no-neck-pain-nvim
    dropbar-nvim
  ];

  baseFonts = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  baseDeps = with pkgs; [
    git
    dbus

    ripgrep
    fd

    lua-language-server
    stylua

    nil
    alejandra

    rustRelease
    taplo
    fixjson
  ];
in {
  config = let
    plugins = map (plugin: plugin.package) config.plugins;

    nvimSrc = pkgs.stdenv.mkDerivation {
      name = "nvim-src";
      src = ./nvim;

      buildPhase = ''
        mkdir -p $out/nvim/plugin
        rm init.lua
      '';

      installPhase = ''
        cp -r after $out/nvim
        cp -r ftplugin $out/nvim
        cp -r lua $out/nvim
        cp -r plugin $out/nvim

        ${
          lib.strings.concatLines
          (map (plugin: "cp ${plugin.config} $out/nvim/plugin") config.plugins)
        }
      '';
    };

    nvimConfig = pkgs.neovim.override {
      configure = {
        customLuaRC =
          ''
            vim.opt.rtp:prepend "${nvimSrc}/nvim"
            vim.opt.rtp:prepend "${nvimSrc}/nvim/after"
            vim.o.shell = "${lib.getExe config.shell}"
          ''
          + (builtins.readFile ./nvim/init.lua);

        packages.myPlugins.start = basePlugins ++ plugins;
      };
    };

    pluginDeps = map (plugin: plugin.runtimeDeps) config.plugins;
    runtimeDeps = baseDeps ++ (lib.lists.flatten pluginDeps);
  in {
    shell = lib.mkDefault pkgs.fish;

    nvim = lib.mkDefault (nvimConfig.overrideAttrs {
      pname = "nvim";

      installPhase = ''
        runHook preInstall

        wrapProgram $out/bin/nvim \
          --prefix PATH : ${lib.makeBinPath (runtimeDeps ++ [config.shell])}

        runHook postInstall
      '';
    });

    rv = pkgs.stdenv.mkDerivation {
      pname = "rv";
      version = "0.0.1";

      src = pkgs.neovide;

      nativeBuildInputs = with pkgs; [
        makeWrapper
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp bin/neovide $out/bin/rv
        wrapProgram $out/bin/rv \
          --add-flag --neovim-bin=${config.nvim}/bin/nvim \
          --prefix XDG_DATA_DIRS : ${lib.makeSearchPath "share" (baseFonts ++ config.fonts)}

        runHook postInstall
      '';

      meta = {
        description = "Graphical neovim configuration for Rust development";
        homepage = "https://github.com/trantorian1/nvim";
        mainProgram = "rv";
      };
    };
  };
}
