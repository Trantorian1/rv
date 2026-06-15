{
  pkgs,
  lib,
  rustRelease,
  ...
}: let
  nvim_cli = pkgs.neovim.override {
    configure = {
      customLuaRC =
        ''
          vim.opt.rtp:prepend "${./nvim}"
          vim.opt.rtp:prepend "${./nvim}/after"
        ''
        + (builtins.readFile ./nvim/init.lua);

      packages.myPlugins = with pkgs.vimPlugins; {
        start = [
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
        ];
      };
    };
  };

  runtimeDeps = with pkgs; [
    nvim_cli
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

  fonts = with pkgs; [nerd-fonts.jetbrains-mono];
in {
  options = {
    nvim = lib.mkOption {
      type = lib.types.package;
    };
  };

  config = {
    nvim = pkgs.stdenv.mkDerivation {
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
          --add-flag --neovim-bin=${nvim_cli}/bin/nvim \
          --prefix PATH : ${lib.makeBinPath runtimeDeps} \
          --prefix XDG_DATA_DIRS : ${lib.makeSearchPath "share" fonts}

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
