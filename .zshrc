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

# propt
eval "$(starship init zsh)"
export STARSHIP_CONFIG=$HOME/starship.toml

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

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# --> add color when completion
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000
setopt share_history          # --> share history between other terminal
setopt hist_ignore_all_dups   # --> ignore duplicates
setopt hist_ignore_space      # --> ignore starting from space
setopt inc_append_history

# --> alias
source $HOME/.aliases

# --> peco
## show list for ghq list
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^l' peco-src

function peco-history() {
    BUFFER=`history -n 1 | tail -r | peco`
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-history
bindkey '^h' peco-history

function peco-cd() {
  local selected_dir=`find . -type d -maxdepth 1 | peco`
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-cd
bindkey '^p' peco-cd

function peco-clipit() {
  local selected_command=`go run main.go list | peco`
  if [ -n "$selected_command" ]; then
    BUFFER="go run main.go exec \"${selected_command}\""
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-clipit
bindkey '^s' peco-clipit