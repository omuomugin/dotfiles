# path
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# mise
eval "$(~/.local/bin/mise activate zsh)"

# sheldon
eval "$(sheldon source)"

## dart & flutter
export PATH="$PATH":"$HOME/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
### Android
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

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

# --> completion setting
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

# --> auto suggestion setting
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

# --> fzf
## show list for ghq list
function fzf-ghq () {
  local selected_dir=$(ghq list -p | fzf --reverse --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    cd ${selected_dir}
  fi
  zle clear-screen
}
zle -N fzf-ghq
bindkey '^l' fzf-ghq

## show list for history
function fzf-history() {
    BUFFER=`history -n 1 | tail -r | fzf --reverse`
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N fzf-history
bindkey '^h' fzf-history

## show list for git-branch
function fzf-git-branch() {
    local selected_branch=$(git branch --format='%(refname:short)' | fzf --reverse)
    if [ -n "$selected_branch" ]; then
      git switch ${selected_branch}
    fi
    zle clear-screen
}
zle -N fzf-git-branch
bindkey '^b' fzf-git-branch

function fzf-git-log() {
    local selected_commit=$(git log --oneline -n 20 | fzf --reverse | awk '{print $1}')
    if [ -n "$selected_commit" ]; then
      BUFFER+="$selected_commit"
      CURSOR=$#BUFFER
      zle redisplay
    fi
    zle clear-screen
}
zle -N fzf-git-log
bindkey '^p' fzf-git-log
