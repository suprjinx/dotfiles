fish_add_path ~/.local/bin
fish_add_path ~/go/bin
set -gx EDITOR "emacs"

if status is-interactive
    # Commands to run in interactive sessions can go here

    # --- Color palette ---
    # `ls` colors. macOS/BSD ls reads LSCOLORS; GNU ls / eza read LS_COLORS.
    # macOS's default palette paints directories in a plain, dark blue that's
    # hard to read on a dark terminal, so bump it to a bright blue.
    #
    # LSCOLORS is 11 fg/bg letter pairs. Lowercase = normal, uppercase = bold/bright.
    # Order: dir, symlink, socket, pipe, exec, block, char, setuid, setgid,
    #        sticky dir, other-writable dir.
    #   dir     -> Ex  bright blue
    #   symlink -> Gx  bright cyan
    #   exec    -> Cx  bright green
    set -gx LSCOLORS ExGxcxdxCxegedabagacad
    set -gx CLICOLOR 1

    # GNU ls / eza equivalent (1;9x = bright variants).
    set -gx LS_COLORS 'di=1;94:ln=1;96:so=1;95:pi=1;93:ex=1;92:bd=1;93:cd=1;93:su=1;91:sg=1;91:tw=1;94:ow=1;94'

    # fish syntax highlighting — brighter, higher-contrast palette
    set -g fish_color_command brblue
    set -g fish_color_param normal
    set -g fish_color_quote yellow
    set -g fish_color_redirection brcyan
    set -g fish_color_end brmagenta
    set -g fish_color_error brred
    set -g fish_color_comment brblack
    set -g fish_color_autosuggestion brblack
    set -g fish_color_operator brcyan
end

for brew_path in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew /usr/local/bin/brew
    if test -x $brew_path
        eval "$($brew_path shellenv fish)"
        break
    end
end
export PATH="$HOME/.local/bin:$PATH"
