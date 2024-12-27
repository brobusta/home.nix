{ config, pkgs, ... }:

{
  home.username = "congvu";
  home.homeDirectory = "/home/congvu";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.tig
    pkgs.curl
    pkgs.wget
    pkgs.htop
    pkgs.eza
    pkgs.fd
    pkgs.bat
    pkgs.ripgrep
    pkgs.coreutils
    pkgs.unzip
    pkgs.tree
    pkgs.wl-clipboard
    pkgs.pfetch
    pkgs.zsh-powerlevel10k
    pkgs.python3Full
    pkgs.python3.pkgs.pip

    # fonts
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.iosevka
    pkgs.noto-fonts-emoji
  ];

  fonts= {
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
    ".config/nvim/lua".source =  builtins.fetchGit {
        url = "git@github.com:brobusta/nvimconfig.git";
        rev = "e7f9cddb488118f4f957f9385ecfc27e0b335653";
    } + "/lua";
    ".config/nvim/init.lua".text = ''
        require("congvu.core")
        require("congvu.lazy")
      '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  programs.home-manager.enable = true;
  programs.ssh.enable = true;

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "JetbrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      include = builtins.toString (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/21ad5c2f1027ed674d1b2cec73ced281f1c1c3f9/extras/kitty/tokyonight_night.conf";
        sha256 = "e92085fb339ca9be916e3bc47fa6813843c6007b155d4f9bcb9fb5af545adc5c";
      });
      scrollback_lines = 100000;
      tab_bar_style = "powerline";
      hide_window_decorations = "yes";
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
    viAlias = true;
  };

  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc;
    plugins = with pkgs.vimPlugins; [
      fzf-vim
      nerdtree
      catppuccin-vim
      vim-airline
      vim-airline-themes
      vim-startify
      vim-polyglot
      # editor
      vim-surround
      vim-commentary
      # linter & completion & snippet
      ale
      asyncomplete-vim
      asyncomplete-lsp-vim
      vim-lsp
      vim-lsp-settings
      vim-lsp-ale
      vim-vsnip
      vim-vsnip-integ
    ];
  };

  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow --glob '!.git/*'";
    defaultOptions = [
    	"--height 40% --layout=reverse --border --bind 'ctrl-y:execute-silent(wl-copy {})'"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude '.git'";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    fileWidgetCommand = defaultCommand;
    fileWidgetOptions = [ "--preview '(bat --style=changes --wrap never --color always {} || cat {} || (eza --tree --group-directories-first {} || tree -C {})) 2> /dev/null' --preview-window right:60%" ];
    historyWidgetOptions = [ "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'" ];
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
      # keybindings
      set-option -g status-position top
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';

    plugins = [
       pkgs.tmuxPlugins.tmux-fzf
       {
         plugin = pkgs.tmuxPlugins.tokyo-night-tmux;
         extraConfig = ''
           set -g @tokyo-night-tmux_show_netspeed 1
           set -g @tokyo-night-tmux_netspeed_showip 1
           set -g @tokyo-night-tmux_netspeed_refresh 5
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
      eval "$(direnv hook zsh)"
    '';
    shellAliases = {
      l = "eza -alh";
      ll = "eza -l";
      ls = "eza";
      v = "vim";
    };
    plugins =  [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

}

