alias routes="zeus rake routes | grep"
alias console="zeus c"
alias db_migrate="zeus rake db:migrate"
alias db_test="zeus rake db:test:prepare"
alias spec="zeus test spec --tag ~type:feature"

# Homebrew (linuxbrew) — add brew and its packages to PATH for login shells
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# source env
source $HOME/.env.sh
