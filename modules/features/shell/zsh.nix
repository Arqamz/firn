# ============================================================================
# ZSH Shell Feature
# ============================================================================
# ZSH with Powerlevel10k, Oh My Zsh, autosuggestions, and syntax highlighting.
# ============================================================================
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
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];

    fonts.packages = with pkgs; [
      meslo-lgs-nf
      nerd-fonts.jetbrains-mono
    ];

    # Add p10k configuration file to /etc/powerlevel10k/p10k.zsh
    environment.etc."powerlevel10k/p10k.zsh".source = inputs.dotfiles.files.zsh.p10k;

    environment.shells = with pkgs; [ zsh ];

    environment.shellAliases = {
      nshell = "nix-shell --run $SHELL";
      ndevelop = "nix develop --command $SHELL";
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
        # Enable Powerlevel10k instant prompt first (before anything else)
        # This must be near the top for the instant prompt to work properly
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Check if we're in a TTY (no nerd font/glyph support)
        if [[ "$TERM" == "linux" || "$TERM" == "vt100" || "$TERM" == "screen"* ]]; then
          setopt prompt_subst

          function git_status_tty() {
            local branch="" staged=0 modified=0 untracked=0 gitstat=""
            if git rev-parse --is-inside-work-tree &>/dev/null; then
              branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
              while read -r line; do
                case "$line" in
                  "??"*) ((untracked++)) ;;            # untracked
                  [MADRC?]*)
                    [[ "${line:0:1}" != " " && "${line:0:1}" != "?" ]] && ((staged++))
                    [[ "${line:1:1}" != " " && "${line:1:1}" != "?" ]] && ((modified++))
                    ;;
                esac
              done <<< "$(git status --porcelain 2>/dev/null)"
              
              gitstat="%F{magenta}$branch%f"
              [[ $staged -gt 0 ]] && gitstat="$gitstat %F{green}+$staged%f"
              [[ $modified -gt 0 ]] && gitstat="$gitstat %F{yellow}!$modified%f"
              [[ $untracked -gt 0 ]] && gitstat="$gitstat %F{red}?$untracked%f"
              
              echo "($gitstat)"
            fi
          }

          PROMPT='%(?.%F{green}√.%F{red}?%?)%f %F{white}%n@%m%f:%F{cyan}%~%f> '
          RPROMPT='$(git_status_tty)'

          # Disable all fancy stuff
          POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

        else

          # ---- Fancy p10k prompt for regular terminal emulators ----

          # Initialize Powerlevel10k
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          
          # Source the p10k configuration file
          [[ -f /etc/powerlevel10k/p10k.zsh ]] && source /etc/powerlevel10k/p10k.zsh
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
