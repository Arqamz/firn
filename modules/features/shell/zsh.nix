{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.features.shell.zsh;
in
{
  options.my.features.shell.zsh.enable = lib.mkEnableOption "zsh shell" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      zsh-powerlevel10k
      meslo-lgs-nf
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];

    # Add p10k configuration file to /etc/powerlevel10k/p10k.zsh
    environment.etc."powerlevel10k/p10k.zsh".source = inputs.dotfiles.files.zsh.p10k;

    environment.shells = with pkgs; [ zsh ];

    environment.shellAliases = {
      nshell = "nix-shell --run $SHELL";
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      histSize = 10000;
      histFile = "$HOME/.zsh_history";

      # Prepare the prompt initialization
      promptInit = ''
        # Powerlevel10k initialization
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        
        # Source the p10k configuration file if it exists
        if [[ -f /etc/powerlevel10k/p10k.zsh ]]; then
          source /etc/powerlevel10k/p10k.zsh
        fi

        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

      ohMyZsh = {
        enable = true;
        plugins = [ "git" "z" "sudo" "extract"];
      };
    };

    # Prevent the new user dialog in zsh
    system.userActivationScripts.zshrc = "touch .zshrc";
  };
}
