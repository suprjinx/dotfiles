alias routes="zeus rake routes | grep"
alias console="zeus c"
alias db_migrate="zeus rake db:migrate"
alias db_test="zeus rake db:test:prepare"
alias spec="zeus test spec --tag ~type:feature"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# source env
source $HOME/.env.sh
