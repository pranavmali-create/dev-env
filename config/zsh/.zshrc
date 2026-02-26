ZSH_PLUGINS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
DISABLE_BELL=true
setopt prompt_subst

HISTFILE="${HISTFILE:-${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history}"
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify

# directory navigation ###
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# completion 
setopt always_to_end
setopt complete_in_word
setopt menu_complete

autoload -U colors && colors

if [[ -z "$LS_COLORS" ]]; then
  if (( $+commands[dircolors] )); then
    [[ -f "$HOME/.dircolors" ]] \
      && eval "$(dircolors -b "$HOME/.dircolors")" \
      || eval "$(dircolors -b)"
  else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
  fi
fi

# load compinit once per day for speed
autoload -Uz compinit
() {
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n $zcompdump(#qNmh-20) ]]; then
    compinit -C -d "$zcompdump"
  else
    compinit -d "$zcompdump"
  fi
}

# completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

function git_prompt_info() {
  [[ -d .git ]] || git rev-parse --git-dir &>/dev/null || return 0
  local ref
  ref=$(GIT_OPTIONAL_LOCKS=0 git symbolic-ref --short HEAD 2>/dev/null) || return 0
  print -n "%{$fg[magenta]%}(${ref:gs/%/%%})%{$reset_color%} "
}

PROMPT="%F{#adadd0}%1~%{$reset_color%} %(?:%{$fg_bold[magenta]%}:%{$fg_bold[red]%})❯%{$reset_color%} "'$(git_prompt_info)'

bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history
bindkey '^r' history-incremental-search-backward

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# source aliases
[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh" ]] && source "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"

extract() {
  [[ -z "$1" ]] && { print "Usage: extract <file>" >&2; return 1; }
  [[ ! -f "$1" ]] && { print "'$1' is not a valid file" >&2; return 1; }
  
  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.bz2)       bunzip2 "$1"      ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           print "'$1' cannot be extracted via extract()" >&2; return 1 ;;
  esac
}

qfind() {
  [[ -z "$1" ]] && { print "Usage: qfind <pattern>" >&2; return 1; }
  find . -name "*$1*"
}

## command line editing in vim
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey -v
export KEYTIMEOUT=1

bindkey -s '^t' 'script-tmux\n'
bindkey -s '^g' 'open-git\n'
# source /usr/share/fzf/key-bindings.zsh

# [[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"
# source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

#the cursor thingy when i go in the insert mode 
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
function zle-line-init {
  echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'

#using help  
function help(){
    bash -c "help $@"
}

