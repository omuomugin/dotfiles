# path
export PATH="$HOME/bin:$PATH"
## java
# --> this maybe more easy to install and set by hand
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
## go
export GOPATH="$HOME/go"
export PATH=$PATH:$(go env GOROOT)/bin:$GOPATH/bin
## ruby
### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
## node
### nodenv
eval "$(nodenv init -)"

# general
setopt no_flow_control
autoload -Uz colors
colors
export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

setopt auto_cd              # --> cd wih directory name only
setopt auto_param_slash     # --> add slash to directory
setopt mark_dirs            # --> add slash to directory
setopt auto_menu            # --> go to next completion with completion command
setopt auto_param_keys      # --> automatically adding brackets
setopt interactive_comments # --> recgnizing after # as a comment
setopt complete_in_word     # --> autocompletion in mid of words
setopt always_last_prompt   # --> show file names
setopt list_types           # --> show list types
setopt no_beep              # --> disable beep sound

# completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'
zstyle ':completion:*' insert-tab false # --> disable tab in empty line
autoload -Uz compinit
compinit
setopt correct
setopt list_packed
setopt auto_param_slash

# --> auto suggestion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# git prompt
source ~/.zsh/git-prompt.sh
setopt PROMPT_SUBST ; PS1='%F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f\$ '

# --> add color when completion
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="(ls|cd|pwd|exit)*"

setopt share_history          # --> share history between other terminal
setopt hist_ignore_all_dups   # --> ignore duplicates
setopt hist_ignore_space      # --> ignore starting from space
setopt inc_append_history

# --> alias
source $HOME/.aliases

# --> peco
## show list for ghq list
function peco-ghq () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq
bindkey '^l' peco-ghq

## show list for history
function peco-history() {
    BUFFER=`history -n 1 | tail -r | peco`
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-history
bindkey '^h' peco-history

## show list for git-branch
function peco-git-branch() {
    local selected_branch=$(git branch --format='%(refname:short)' | peco )
    if [ -n "$selected_branch" ]; then
      BUFFER="git switch ${selected_branch}"
      zle accept-line
    fi
    zle clear-screen
}
zle -N peco-git-branch
bindkey '^b' peco-git-branch

function peco-git-log() {
    local selected_commit=$(git log --oneline -n 20 | peco | awk '{print $1}')
    if [ -n "$selected_commit" ]; then
      BUFFER+="$selected_commit"
      CURSOR=$#BUFFER
      zle redisplay
    fi
    zle clear-screen
}
zle -N peco-git-log
bindkey '^p' peco-git-log


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/01027754/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/01027754/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/01027754/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/01027754/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
