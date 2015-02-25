if [[ "$TERM" == dumb ]]; then
  return 1
fi

# completions {{{
# Add zsh-completions to $fpath.
fpath=(/usr/local/share/zsh-completions $fpath)

# Load and initialize the completion system ignoring insecure directories.
autoload -Uz compinit && compinit

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.

# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
setopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
#zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}
# environment variables for interactive shells {{{

# fix colors in terminal
# https://github.com/chriskempson/base16-shell
if [[ -f ~/.zsh/base16-tomorrow.dark.sh ]]; then
  . ~/.zsh/base16-tomorrow.dark.sh
fi

export CLICOLOR=1 # for ls
export CTAGS='--exclude=.git --python-kinds=-i --recurse=yes'
export EDITOR=vim
export GREP_COLOR='30;41' # black on red
export GREP_COLORS='ms=30;41:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
export GREP_OPTIONS='--color=auto'
export LESS='--quit-if-one-screen --no-init --RAW-CONTROL-CHARS'
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.
export PAGER=less
export VISUAL=$EDITOR
# }}}
# key bindings {{{
# vim style keybindings
bindkey -v

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# arrow keys prefix search
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end

# make forward delete work
bindkey '\033[3~' delete-char

# bash-style backward search
bindkey '^R' history-incremental-pattern-search-backward
# }}}
# options {{{
# zmv, rename files
autoload -U zmv

# no delay when pressing ESC
KEYTIMEOUT=1

REPORTTIME=10
export REPORTTIME=10

setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_MINUS
setopt PUSHD_IGNORE_DUPS

setopt INTERACTIVECOMMENTS # allow comments on command line
setopt COMBINING_CHARS # Combine zero-length punctuation characters (accents) with the base character.

# }}}
# history {{{
HISTFILE=~/.zhistory
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
# }}}
# prompt {{{
# make substitutions work in prompt
setopt prompt_subst

RPROMPT="%F{19}-_-%f %F{166}%D{%H.%M.%S}%f"
if [[ $TERM == 'screen' ]]; then
  # [$HOSTNAME] $PWD
  PROMPT='%(?..%{%F{red}%}%?%{%f%} )[%m] %{%F{yellow}%}%~%{%f%} '
elif [[ -n $SSH_TTY && -z $TMUX ]]; then
  # $HOSTNAME $PWD
  PROMPT='%(?..%{%F{red}%}%?%{%f%} )%m %{%F{yellow}%}%~%{%f%} '
else
  # $PWD
  PROMPT='%(?..%{%F{red}%}%?%{%f%} )%{%F{yellow}%}%~%{%f%} '
fi
# }}}
# aliases {{{
alias colors='( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done; )'
alias v='vim ~/Documents/log.txt'
alias l='>> ~/Documents/log.txt echo $(date "+%Y-%m-%d %H.%M")'
# }}}
# git profiles {{{
function chpwd_profile_default() {
  if [[ ${profile} == ${CHPWD_PROFILE} ]]; then
    return 1
  fi
  unset GIT_AUTHOR_EMAIL GIT_COMMITTER_EMAIL
}

function chpwd_profile_edgeware() {
  if [[ ${profile} == ${CHPWD_PROFILE} ]]; then
    return 1
  fi
  export GIT_AUTHOR_EMAIL=joakim.bergman@edgeware.tv GIT_COMMITTER_EMAIL=joakim.bergman@edgeware.tv
}

if [[ $ZSH_VERSION == 4.3.<3->* || $ZSH_VERSION == 4.<4->* || $ZSH_VERSION == <5->* ]]; then
  CHPWD_PROFILE='default'
  function chpwd_profiles()
  {
    local -x profile

    zstyle -s ":chpwd:profiles:${PWD}" profile profile || profile='default'
    if (( ${+functions[chpwd_profile_$profile]} )); then
      chpwd_profile_${profile}
    fi

    CHPWD_PROFILE="${profile}"
    return 0
  }
  chpwd_functions=(${chpwd_functions} chpwd_profiles)
fi
zstyle ':chpwd:profiles:*edgeware(|/|/*)' profile edgeware
# }}}

if [[ -f ~/.zshrc.local ]]; then
  . ~/.zshrc.local
fi

# vim: fdm=marker:
