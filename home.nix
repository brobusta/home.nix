{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.username = "congvu";
  home.homeDirectory = "/home/congvu";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bat
    btop
    coreutils
    cowsay
    curl
    eza
    fd
    fortune
    helix
    htop
    lazygit
    pfetch
    python3.pkgs.pip
    python3Full
    ripgrep
    tig
    tree
    unzip
    wget
    wl-clipboard
    yazi

    # fonts
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
    noto-fonts-emoji
  ];

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetbrainsMono Nerd Font"
          "Iosevka Nerd Font"
        ];
        sansSerif = [
          "JetbrainsMono Nerd Font"
          "Iosevka Nerd Font"
        ];
        serif = [
          "JetbrainsMono Nerd Font"
          "Iosevka Nerd Font"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
        ];
      };
    };
  };

  home.file = {
    ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink ./nvim.lua;
    ".config/eza/theme.yml".source = "${pkgs.vimPlugins.tokyonight-nvim}/extras/eza/tokyonight.yml";
    ".config/yazi/theme.toml".source =
      "${pkgs.vimPlugins.tokyonight-nvim}/extras/yazi/tokyonight_night.toml";
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host work-pc
        HostName 10.48.70.40
        User cong.vu
      Host work-lt
        HostName 10.48.71.222
        User cong.vu
    '';
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "JetbrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      include = builtins.readFile "${pkgs.vimPlugins.tokyonight-nvim}/extras/kitty/tokyonight_night.conf";
      scrollback_lines = 100000;
      tab_bar_style = "powerline";
      hide_window_decorations = "yes";
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
    };
  };

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Vu Thanh Cong";
    userEmail = "vuthanhcong.ict@gmail.com";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimdiffAlias = true;
    # extraLuaConfig = builtins.readFile ./nvim.lua;
  };

  programs.vim = {
    # use neovim for now
    enable = false;
    extraConfig = lib.mkMerge [
      ''
        set rtp+=${pkgs.vimPlugins.tokyonight-nvim}/extras/vim
      ''
      (builtins.readFile ./vimrc)
    ];
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      nerdtree
      tokyonight-nvim
      vim-airline
      vim-airline-themes
      vim-devicons
      vim-polyglot
      vim-startify
      # editor
      vim-commentary
      vim-surround
      # linter & completion & snippet
      ale
      asyncomplete-lsp-vim
      asyncomplete-vim
      vim-lsp
      vim-lsp-ale
      vim-lsp-settings
      vim-vsnip
      vim-vsnip-integ
    ];
  };

  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*'";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--bind 'ctrl-y:execute-silent(wl-copy {})'"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude '.git'";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = [
      "--preview '(bat --style=changes --wrap never --color always {} || cat {} || (eza --tree --group-directories-first {} || tree -C {})) 2> /dev/null'"
      "--preview-window right:60%"
    ];
    historyWidgetOptions = [
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
    ];
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 1000000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-space";
    terminal = "tmux-256color";
    customPaneNavigationAndResize = true;

    extraConfig = ''
      set-option -g status-position top
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';

    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_show_netspeed 1
          set -g @tokyo-night-tmux_netspeed_showip 1
          set -g @tokyo-night-tmux_netspeed_refresh 5
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-dir "$HOME/.cache/tmux/resurrect"
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      expireDuplicatesFirst = true;
      save = 100000000;
      size = 100000000;
    };
    initExtra = ''
      [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      [ -f $HOME/.p10k.zsh ] && source $HOME/.p10k.zsh
      fzfTheme=${pkgs.vimPlugins.tokyonight-nvim}/extras/fzf/tokyonight_night.sh
      [ -f "$fzfTheme" ] && source "$fzfTheme"
      [ -f $HOME/.congvu.localrc ] && source $HOME/.congvu.localrc
    '';
    shellAliases = {
      l = "eza -alh";
      ll = "eza -l";
      ls = "eza";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      y = "yazi";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "fzf"
        "git"
        "history"
        "direnv"
      ];
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight";
    };
    themes = {
      tokyonight = {
        src = pkgs.vimPlugins.tokyonight-nvim;
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyonight";
      vim_keys = true;
      rounded_corners = true;
      theme_background = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}
