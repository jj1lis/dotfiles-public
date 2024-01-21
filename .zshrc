# Parameters
PYENV_VERSION="3.12.0"
D_VERSION="dmd-2.106.1"

# Language
export LANGUAGE=en_US


# Utility alias
if [ -x /usr/bin/dircolors ]; then      # color
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ll="ls -l --color=auto"
    alias la="ls -la --color=auto"
    alias lh="ls -lha --color=auto"
    alias l="ls --color=auto"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ll="ls -l"
    alias la="ls -la"
    alias lh="ls -lha"
    alias l="ls"
fi


# Default editor
export EDITOR="vim"
export VISUAL="$EDITOR"


# PATH
# TODO: improve
# TeXLive
export PATH="$PATH:/usr/local/texlive/2023/bin/x86_64-linux"
export MANPATH="$MANPATH:/usr/local/texlive/2023/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2023/texmf-dist/doc/info"
# R
export PATH="$PATH:/usr/local/MATLAB/R2023a/bin/"
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# pyenv global $PYENV_VERSION


# Neovim
if [ -x "$(command -v nvim)" ]; then    # nvim is already available
    :
elif [ -f ~/nvim/nvim.appimage ]; then
    alias nvim="~/nvim/nvim.appimage"
fi

# Dlang
if [ -e $HOME/dlang/$D_VERSION/ ]; then
    source $HOME/dlang/$D_VERSION/activate
else
    echo "$D_VERSION is not activated: $HOME/dlang/$D_VERSION/ not found."
fi


# Load sheldon
if [ -x "$(command -v sheldon)" ]; then   # when sheldon is installed
    eval "$(sheldon source)"
fi


# Prompt
# default
export PROMPT="%B%F{red}%n%f%F{green}@%M%f:%F{blue}%~ \$%f%b "
# Setup powerline-shell
function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
    for s in "${precmd_functions[@]}"; do
        if [ "$s" = "powerline_precmd" ]; then
            return
        fi
    done
    precmd_functions+=(powerline_precmd)
}

if [ "$TERM" = "linux" ]; then
    echo "powerline-shell is not available in this terminal."
elif [ -x "$(command -v powerline-shell)" ]; then
    # TODO: investigate problem
    # install_powerline_precmd
else
    echo "powerline-shell not found."
fi


# thefuck
if [ -x "$(command -v thefuck)" ]; then
    eval "$(thefuck --alias)"
fi


# xclip
if [ -x "$(command -v xclip)" ]; then
    alias xboard="xclip -selection c"
fi


# fortune!
if [ -x "$(command -v fortune)" ]; then
    if [ -x "$(command -v cowsay)" ]; then
        fortune -a | cowsay
    else
        fortune -a
    fi
fi

# Setup fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -x $(command -v rg) ]; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
fi
if [ -x $(command -v fd) ]; then
    export FZF_CTRL_T_COMMAND="fd --hidden --exclude '.git'"
fi
export FZF_DEFAULT_OPTS='--height 60% --reverse --border --cycle'
