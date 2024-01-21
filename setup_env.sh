#!/bin/bash

confirm () {
    while true; do
        read input
        if [[ $input = "yes" ]] || [[ $input = "y" ]]  || [[ $input = "YES" ]] || [[ $input = "Yes" ]]; then
            echo 0
            return 0
        elif [[ $input = "no" ]] || [[ $input = "n" ]]  || [[ $input = "NO" ]] || [[ $input = "No" ]]; then 
            echo 1
            return 1
        else
            echo -n "Input 'yes' or 'no' :" 1>&2
        fi
    done
}

DATE="$(data +%Y%m%d%G%I%M%S)"

# Checking directory
REPO_URL="git@github.com:jj1lis/dotfiles.git"

if [[ ! $(pwd) =~ ^.*/dotfiles$ ]]; then
    echo "Current directory is ${current_dir}."
    echo "Excecute at 'dotfiles/'."
    exit 1
fi
current_repo="$(git config --get remote.origin.url)"
if [[ ${current_repo} != ${REPO_URL} ]]; then
    echo "Git file of 'git@github.com:jj1lis/dotfiles.git' not found."
    echo -n "Is this directory realy same as the repository? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        echo "Process will be continued but don't check the branch."
    else
        echo "Aborted."
        exit 1
    fi
fi
current_branch=$(git rev-parse --abbrev-ref HEAD)
echo "You are in branch '${current_branch}'"
echo -n "Continue the setup on this branch? [y/n] :"
if [[ $(confirm) -eq 0 ]]; then
    echo "Start setup."
else
    echo "Aborted."
    exit 0
fi
echo
ROOT="$(pwd)"


# Determine OS
echo "[Determining OS]"
OS="Unknown"
if [[ "$(uname)" = "Darwin" ]]; then
    OS="Mac"
elif [[ "$(uname)" = "Linux" ]]; then
    OS="Linux"
fi
echo "OS = $OS"
echo


# Setup Programs

# Package managers
echo "***Setup package managers***"
# APT (Ubuntu only)
echo "[Checking APT]"
APT=false
# TODO: improve
if [[ -x "$(command -v apt)" ]]; then
    echo "APT is already installed."
    APT=true
fi

if "$APT"; then
    echo "\$ sudo apt update"
    sudo apt update
fi
echo

# Homebrew (Mac only)
echo "[Checking Homebrew]"
BREW=false
if [[ -x "$(command -v brew)" ]]; then
    echo "Homebrew is already installed."
    BREW=true
elif [[ $OS = "Mac" ]]; then    # only if OS is Mac and when homebrew is not installed
    echo -n "Install Homebrew? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        echo '\$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        if [[ $? ]]; then
            BREW=true
        else
            echo "Homebrew installation faild."
        fi
    else
        echo "Homebrew was not installed."
    fi
fi

if "$BREW"; then
    echo "\$ brew update"
    brew update
fi
echo


# cargo
echo "[Checking cargo]"
CARGO=false
if [[ -x "$(command -v cargo)" ]]; then   # when cargo is available
    echo "cargo is already installed."
    CARGO=true
else                                    # cargo is not able to be installed
    echo -n "Install rustup for cargo? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        echo "Installing rustup..."
        echo "\$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        if [[ $? ]]; then
            CARGO=true
        else
            echo "cargo installation failed."
        fi
    else
        echo "cargo was not installed."
    fi
fi

if "$CARGO"; then
    echo "\$ cargo update"
    cargo update
fi
echo


# pyenv
echo "[Checking pyenv]"
PYENV=false
echo "Adding pyenv to PATH for this session."
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
if [[ -x $(command -v pyenv) ]]; then
    echo "pyenv is already installed."
    PYENV=true
else
    echo -n "Install pyenv? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$BREW"; then
            echo "\$ brew install pyenv"
            brew install pyenv
        else
            echo "\$ git clone git@github.com:pyenv/pyenv.git ~/.pyenv"
            git clone git@github.com:pyenv/pyenv.git ~/.pyenv
        fi
        if [[ $? ]]; then
            PYENV=true
        else
            echo "pyenv installation failed."
        fi
    else
        echo "pyenv was not installed."
    fi
fi

# TODO: make version be configured in a config file.
if "$PYENV"; then
    echo "Initializing pyenv"
    eval "$(pyenv init -)"
    echo "Installing python 2 & 3 with pyenv."
    pyenv install 2.7.18
    pyenv install 3.12.0
    echo "Changing pyenv version to 2.7.18 preparing to use pip."
    pyenv local 2.7.18
fi
echo


# pip
echo "[Checking pip]"
PIP=false
if [[ -x "$(command -v pip)" ]]; then   # when cargo is available
    echo "pip is already installed."
    PIP=true
fi
echo

# Applications

# Neovim
echo "[Neovim Installation]"
if [[ -x "$(command -v nvim)" || -x "$HOME/nvim/nvim.appimage" ]]; then
    echo "Neovim is already installed."
else
    echo -n "Install Neovim? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$BREW"; then
            echo "\$ brew install nvim"
            "brew install nvim"
        elif [[ $OS = "Linux" ]]; then
            echo "Install image to $HOME/nvim/."

            # Checking directory
            if [[ ! -d $HOME/nvim ]]; then
                "\$ mkdir $HOME/nvim"
                mkdir $HOME/nvim
            fi

            # Checking existing file
            if [[ -f $HOME/nvim/nvim.appimage ]]; then
                echo "'$HOME/nvim/nvim.appimage' is already exist."
                echo "Renaming it to 'nvim.appimage.back$DATE'. (Checking the file after processing!)"
                echo "\$ mv $HOME/nvim/nvim.appimage $HOME/nvim/nvim.appimage.back$DATE"
                mv $HOME/nvim/nvim.appimage $HOME/nvim/nvim.appimage.back
            fi

            # Download file
            echo "\$ curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $HOME/nvim/nvim.appimage"
            curl -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage -o $HOME/nvim/nvim.appimage
            echo "\$ chmod u+x $HOME/nvim/nvim.appimage"
            chmod u+x $HOME/nvim/nvim.appimage

            if [[ -x "$HOME/nvim/nvim.appimage" ]]; then
                echo "Installation successed."
            else
                echo "Installation failed."
            fi
        else
            echo "Script doesn't support this environment. Do it manually."
        fi
    else
        echo "Neovim was not installed."
    fi
fi
echo

# Dlang
echo "[Dlang Installation]"
# TODO: make version be configured in a config file.
D_VERSION="dmd-2.106.1"

echo "Checking GPG (GNU Public Guard)...."
if [[ ! -x $(command -v gpg) ]]; then
    echo "Install GPG."
    if "$APT"; then
        echo "\$ sudo apt install gpg"
        sudo apt install gpg
    elif "$BREW"; then
        echo "\$ brew install gpg"
        sudo brew install gpg
    else
        echo "Script doesn't support this environment. Do it manuallt."
    fi
fi

if [[ ! -d $HOME/dlang ]]; then
    echo "\$ mkdir $HOME/dlang/"
    mkdir $HOME/dlang/
fi

if [[ -d $HOME/dlang/$D_VERSION ]]; then
    echo "Dlang version $D_VERSION already installed. Installation skiped."
else
    echo "Updating GPG keyring."
    if [[ -f $HOME/dlang/d-keyring.gpg ]]; then
        echo "Keyring file '$HOME/dlang/d-keyring.gpg' already exists. Make backup."
        echo "Renaming it to '$HOME/dlang/d-keyring.gpg.back$DATE'... (Checking the file after processing!)"
        mv $HOME/dlang/d-keyring.gpg $HOME/dlang/d-keyring.gpg.back$DATE
    fi
    echo "Downloading keyring file."
    echo "\$ wget https://dlang.org/d-keyring.gpg -O $HOME/dlang/d-keyring.gpg"
    wget https://dlang.org/d-keyring.gpg -O $HOME/dlang/d-keyring.gpg

    echo "Update public key."
    if [[ -f $HOME/dlang/d-security.asc.gpg ]]; then
        echo "Keyring file '$HOME/dlang/d-security.asc.gpg' already exists. Make backup."
        echo "Renaming it to '$HOME/dlang/d-security.asc.gpg.back$DATE'... (Checking the file after processing!)"
        mv $HOME/dlang/d-security.asc.gpg $HOME/d-security.asc.gpg.back$DATE
    fi
    echo "Downloading public ley."
    echo "\$ wget https://dlang.org/d-security.asc.gpg -O $HOME/dlang/d-security.asc.gpg"
    wget https://dlang.org/d-security.asc.gpg -O $HOME/dlang/d-security.asc.gpg

    echo "Downloading keyring file."
    echo "\$ wget https://dlang.org/d-keyring.gpg -O $HOME/dlang/d-keyring.gpg"
    wget https://dlang.org/d-keyring.gpg -O $HOME/dlang/d-keyring.gpg

    echo "Downloading the install script."
    echo "\$ wget https://dlang.org/install.sh -O $HOME/dlang/install.sh && chmod u+x $HOME/dlang/install.sh"
    wget https://dlang.org/install.sh -O $HOME/dlang/install.sh && chmod u+x $HOME/dlang/install.sh
    if [[ $? ]]; then
        echo "Installing Dlang version $D_VERSION."
        echo "\$ $HOME/dlang/install.sh update"
        $HOME/dlang/install.sh update
        echo "\$ $HOME/dlang/install.sh install $D_VERSION"
        $HOME/dlang/install.sh install $D_VERSION
    fi
fi
echo

# thefuck
echo "[thefuck Installation]"
if [[ -x "$(command -v thefuck)" ]]; then
    echo "thefuck is already installed."
else
    echo -n "Install thefuck? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$BREW"; then
            echo "\$ brew install thefuck"
            brew install thefuck
        elif "$PIP"; then
            echo "\$ pip install thefuck"
            pip install thefuck
        elif "$APT"; then
            echo "\$ sudo apt install python3-dev python3-pip python3-setuptools"
            sudo apt install python3-dev python3-pip python3-setuptools
            echo "\$ pip3 install thefuck"
            pip3 install thefuck
        else
            :
        fi
    fi
fi
echo

# xclip
echo "[xclip Installation]"
if [[ -x "$(command -v xclip)" ]]; then
    echo "xclip is already installed."
else
    echo -n "Install xclip? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$APT"; then
            echo "\$ sudo apt install xclip"
            sudo apt install xclip
        elif "$BREW"; then
            echo "\$ brew install xclip"
            brew install xclip
        else
            :
        fi
    fi
fi
echo

# fortune
echo "[fortune Installation]"
if [[ -x "$(command -v fortune)" ]]; then
    echo "fortune is already installed."
else
    echo -n "Install fortune? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$APT"; then
            echo "\$ sudo apt install fortune"
            sudo apt install fortune
        elif "$BREW"; then
            echo "\$ brew install fortune"
            brew install fortune
        else
            :
        fi
    fi
fi
echo

# cowsay
echo "[cowsay Installation]"
if [[ -x "$(command -v cowsay)" ]]; then
    echo "cowsay is already installed."
else
    echo -n "Install cowsay? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$APT"; then
            echo "\$ sudo apt install cowsay"
            sudo apt install cowsay
        elif "$BREW"; then
            echo "\$ brew install cowsay"
            brew install cowsay
        else
            :
        fi
    fi
fi
echo

# sheldon
echo "[sheldon Installation]"
if [[ -x "$(command -v sheldon)" ]]; then 
    echo "sheldon is already installed."
else # when sheldon is not installed
    echo -n "Install sheldon? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$BREW"; then
            echo "\$ brew install sheldon"
            brew install sheldon
        elif "$CARGO"; then
            echo "\$ cargo install sheldon"
            cargo install sheldon
        else                                    # cargo is not able to be installed
            echo "\$ curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin"
            curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
                | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
            [[ ! $? ]] && echo "sheldon installation faild."
        fi
    else
        echo "sheldon was not installed."
    fi
fi
echo

# powerline-shell
echo "[powerline-shell Installation]"
if [[ -x "$(command -v powerline-shell)" ]]; then
    echo "powerline-shell is already installed."
else # when sheldon is not installed
    echo -n "Install powerline-shell? [y/n] :"
    if [[ $(confirm) -eq 0 ]]; then
        if "$PIP"; then
            echo "\$ pip install powerline-shell"
            pip install powerline-shell
            [[ ! $? ]] && echo "powerline-shell installation faild."
        else 
            echo "pip is needed to install powerline-shell. Install python2."
            # TODO: improve
        fi
    else
        echo "powerline-shell was not installed."
    fi
fi
echo


# Expand dotfiles
echo "***Expantion dotfiles***"

# Neovim
echo "[Copying '.config/nvim']"
if [[ ! -d $HOME/.config ]]; then
    echo "\$ mkdir $HOME/.config"
    mkdir $HOME/.config
fi

if [[ ! -d $HOME/.config/nvim ]]; then
    echo "\$ cp -r $ROOT/.config/nvim $HOME/.config/"
    cp -r $ROOT/.config/nvim $HOME/.config/
elif [[ ! $(diff -r $HOME/.config/nvim $ROOT/.config/nvim) ]]; then
    echo "Directory '$HOME/.config/nvim' is already up-to-date on the repository. Copying skiped."
else
    echo "Directory '$HOME/.config/nvim' already exists. "
    echo "Renaming it to '$HOME/.config/nvim.back$DATE'... (Checking the file after processing!)"
    mv $HOME/.config/nvim $HOME/.config/nvim.back$DATE
    echo "\$ cp -r $ROOT/.config/nvim $HOME/.config/"
    cp -r $ROOT/.config/nvim $HOME/.config/
fi
echo


# Vim
echo "[Copying '.vimrc']"
if [[ ! -f $HOME/.vimrc ]]; then
    echo "\$ cp $ROOT/.vimrc $HOME"
    cp $ROOT/.vimrc $HOME
elif [[ ! $(diff $HOME/.vimrc .vimrc) ]]; then
    echo "File '$HOME/.vimrc' is already up-to-date on the repository. Copy skiped."
else
    echo "File '$HOME/.vimrc' already exists. "
    echo "Renaming it to '$HOME/.vimrc.back$DATE'... (Checking the file after processing!)"
    mv $HOME/.vimrc $HOME/.vimrc.back$DATE
    echo "\$ cp $ROOT/.vimrc $HOME"
    cp $ROOT/.vimrc $HOME
fi
echo

echo "[Copying '.vim']"
if [[ ! -d $HOME/.vim ]]; then
    echo "\$ cp -r $ROOT/.vim $HOME"
    cp -r $ROOT/.vim $HOME
elif [[ ! $(diff -r $HOME/.vim .vim) ]]; then
    echo "Directory '$HOME/.vim' is already up-to-date on the repository. Copy skiped."
else
    echo "Directory '$HOME/.vim' already exists. "
    echo "Renaming it to '$HOME/.vim.back$DATE'... (Checking the file after processing!)"
    mv $HOME/.vim $HOME/.vim.back$DATE
    echo "\$ cp -r $ROOT/.vim $HOME"
    cp -r $ROOT/.vim $HOME

    echo "Execute :PlugInstall in Vim after processing to install Vim plugins!"
fi
echo


# zsh
echo "[Copying '.zshrc']"
if [[ ! -f $HOME/.zshrc ]]; then
    echo "\$ cp $ROOT/.zshrc $HOME"
    cp $ROOT/.zshrc $HOME
elif [[ ! $(diff $HOME/.zshrc .zshrc) ]]; then
    echo "File '$HOME/.zshrc' is already up-to-date on the repository. Copy skiped."
else
    echo "File '$HOME/.zshrc' already exists. "
    echo "Renaming it to '$HOME/.zshrc.back$DATE'... (Checking the file after processing!)"
    mv $HOME/.zshrc $HOME/.zshrc.back$DATE
    echo "\$ cp $ROOT/.zshrc $HOME"
    cp $ROOT/.zshrc $HOME
fi
