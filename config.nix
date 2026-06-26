{
  config,
  pkgs,
  lib,
  rust,
  ...
}: let
  deadcolumn = pkgs.vimUtils.buildVimPlugin {
    name = "deadcolumn-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Bekaboo";
      repo = "deadcolumn.nvim";
      tag = "v1.0.2";
      hash = "sha256-/EtRvosijeVAMa7vQhcrFRkOs+gslDUHmbvbIGTjqr8=";
    };
  };

  basePlugins = with pkgs.vimPlugins; [
    # Common deps
    plenary-nvim
    nvim-web-devicons
    nui-nvim
    snacks-nvim

    (nvim-treesitter.withPlugins (
      plugins: [
        plugins.nix
        plugins.lua
        plugins.rust
        plugins.json
        plugins.yaml
        plugins.toml
        plugins.c
      ]
    ))

    # Search
    telescope-nvim
    telescope-ui-select-nvim
    telescope-fzf-native-nvim

    # git
    git-blame-nvim
    diffview-nvim
    gitsigns-nvim
    oil-git-nvim

    #  lsp
    fidget-nvim
    nvim-lspconfig
    rustaceanvim

    # debug
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text

    # edit
    oil-nvim
    nvim-autopairs
    blink-cmp
    luasnip
    conform-nvim
    comment-nvim
    flash-nvim
    vim-visual-multi
    neogen
    nvim-treesitter-context
    precognition-nvim

    # visual
    nvim-notify
    todo-comments-nvim
    catppuccin-nvim
    auto-dark-mode-nvim
    bufferline-nvim
    colorful-winsep-nvim
    helpview-nvim
    lualine-nvim
    render-markdown-nvim
    noice-nvim
    rainbow-delimiters-nvim
    nvim-scrollbar
    edgy-nvim
    which-key-nvim
    smart-splits-nvim
    no-neck-pain-nvim
    dropbar-nvim
    deadcolumn
  ];

  baseFonts = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  baseDeps = with pkgs; [
    # common
    git
    dbus
    gcc

    # search
    ripgrep
    fd

    # lua
    lua-language-server
    stylua

    # nix
    nil
    alejandra

    # rust
    rust
    graphviz
    taplo
    vscode-extensions.vadimcn.vscode-lldb.adapter

    # json
    fixjson
  ];
in {
  config = let
    plugins =
      builtins.filter (package: package != null)
      (map (plugin: plugin.package) config.plugins);

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

        ${lib.strings.concatLines (map (plugin: "cp ${plugin.config} $out/nvim/plugin") config.plugins)}
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

    nvim = lib.mkDefault (
      nvimConfig.overrideAttrs {
        pname = "nvim";

        installPhase = ''
          runHook preInstall

          wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath (runtimeDeps ++ [config.shell])}

          runHook postInstall
        '';
      }
    );

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
