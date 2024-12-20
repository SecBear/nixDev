# ~.dotfiles/modules/zsh/default.nix
{ pkgs, lib, config, ... }:
{
    home.packages = with pkgs; [
      zsh
      fzf
    ];

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;

      dotDir = ".config/zsh";

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initExtra = ''
        bindkey "^[[1;3C" forward-word                  # Key Alt + Right
        bindkey "^[[1;3D" backward-word                 # Key Alt + Left
      '';

      shellAliases = {
        cat = "bat";
        cd = "z";
        vi = "nvim";
        vim = "nvim";
        ls = "eza --icons";
        ll = "eza --icons -lah";
        tree = "eza --tree --icons";
        kali = "distrobox enter --root kali-rolling";
        kali-create = "distrobox create --root kalilinux/kali-rolling";
        arch = "distrobox enter --root archlinux";
        arch-create = "distrobox create --root archlinux";
        drs = "darwin-rebuild switch --flake ~/.dotfiles/"; 
        # Create nix script
        nxs = ''f() { 
        if [ -z "$1" ]; then
          echo "Usage: nxs <filename>.sh"
          return 1
        fi
        echo "#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash <packages> # Seperate packages by space
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/<commit_hash>.tar.gz

# Script here
" > $1 && chmod +x $1 && vim $1; }; f'';
 
      };

      plugins = with pkgs; [
        {
          name = "powerlevel10k";
          src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
          file = "powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./.;
          file = ".p10k.zsh";
        }
        {
          name = "fzf-zsh";
          src = "${fzf-zsh}/share/zsh/plugins/fzf-zsh";
          file = "fzf-zsh.plugin.zsh";
        }
        #{
        #  name = "sudo-zsh";
        #  src = ./.;
        #  file = "sudo.plugin.zsh";
        #}
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
      ];
    };
}
