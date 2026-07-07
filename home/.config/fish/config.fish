fish_add_path ~/.local/bin
fish_add_path ~/go/bin
set -gx EDITOR "emacs"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

for brew_path in /home/linuxbrew/.linuxbrew/bin/brew /opt/homebrew/bin/brew /usr/local/bin/brew
    if test -x $brew_path
        eval "$($brew_path shellenv fish)"
        break
    end
end
