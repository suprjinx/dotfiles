# User configuration

export PATH="$HOME/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/Scripts:$HOME/.go/bin"

# export MANPATH="/usr/local/man:$MANPATH"

export GOPATH=~/.go
#source "$GOPATH/src/github.com/sachaos/todoist/todoist_functions.sh"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
export TERM=xterm-256color
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw"
# if [ -n "$INSIDE_EMACS" ]; then
#   export EDITOR=emacsclient
#   unset zle_bracketed_paste  # This line
# fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias routes="spring rake routes | grep"
alias rc="spring rails c"
alias spec="spring rspec spec --tag ~type:feature"
alias em="emacsclient -nw"
alias lpcp="lpass ls | percol | grep -oE \"[0-9]+\" | xargs lpass show -cp"
alias lps="lpass ls | percol | grep -oE \"[0-9]+\" | xargs lpass show"
#eval "$(rbenv init -)"
alias zeus="docker-compose exec web zeus"

alias jb="jira issue jql \"sprint in openSprints() and assignee='daveg' and status='Backlog'\""
alias jm="jira issue jql \"sprint in openSprints() and assignee='gewilson' and status='In\ Progress'\""

jkey () {
    grep -oE "FCP-[0-9]+" $1
}

jopen () {
    jira issue open $1
}

jtake () {
    jira issue assign $1 gewilson
    jira issue trans $1 start
}

jdeliver () {
    jira issue trans $1 deliver
}
