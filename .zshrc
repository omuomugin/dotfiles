# path
export PATH="$HOME/bin:$PATH"
## java
# --> this maybe more easy to install and set by hand
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
## go
export GOPATH="$HOME/src"
export PATH=$PATH:$(go env GOROOT)/bin:$GOPATH/bin
## ruby
### rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"
# node
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# --> auto suggestion (which will be installed by hombrew)
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# --> add color when completion
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=1000
SAVEHIST=1000
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "
setopt share_history          # --> share history between other terminal
setopt hist_ignore_dups       # --> ignore duplicates
setopt hist_ignore_space      # --> ignore starting from space
setopt extended_history       # --> adding timestamp

# alias
## --> general
alias bd='cd ../'             # --> back directroy
alias restart='exec zsh -l'   # --> reset setting
alias help='alias-help'       # --> reset setting

## --> git
### basic info
alias gs='git status'
alias gd='git diff'
alias gl='git log'

### local actions
alias ga='git add -A'
alias gcb='git checkout -b'
alias gcm='git commit -m'
alias gp='git push'

### branch
alias gb='git branch'
alias gbd='git-branch-delete-by-name' # --> defined as function
alias gbn='git-branch-by-name' # --> defined as function

### for OSS
alias gau='git remote add upstream'
alias gmu='git-merge-upstream' # --> defined as function

function alias-help () {
  echo "
bd='cd ../'
restart='exec zsh -l'

gs='git status'
gd='git diff'
gl='git log'

ga='git add -A'
gcb='git checkout -b'
gcm='git commit -m'
gp='git push'

gb='git branch'
gbd='git-branch-delete-by-name'
gbn='git-branch-by-name'

gau='git remote add upstream'
gmu='git-merge-upstream'
"
}

# function
# --> git
## delete all the branches starting with given word
function git-branch-delete-by-name () {
  git branch | grep $1 | tr -d ' ' | tr -d '*' | while read _branch; do git branch -D ${_branch}; done
}

## get branch name with name
function git-branch-by-name () {
  git branch | grep $1 | tr -d ' ' | tr -d '*' | while read _branch; do echo ${_branch}; done
}

## merge master of upstream
### this will be used for OSS commitment
function git-merge-upstream () {
  git fetch upstream
  git checkout master
  git merge uptream/master
  git push
}

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
