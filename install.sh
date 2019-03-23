#!/bin/bash

green="\e[36m"
blue="\e[34m"
normal="\e[0m"

success () {
    printf "${green}$1${normal}\n"
}

info () {
    printf "${blue}$1${normal}\n"
}

sudo apt-get -qqy update
sudo apt-get -qqy install curl zsh tmux

# oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    success "oh-my-zsh installed"
fi

# powerlevel9k
if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel9k ]; then
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    success "powerlevel9k installed"
fi

# zsh-syntax-highlighting
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    success "zsh-syntax-highlighting installed"
fi

# zsh-autosuggestions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    success "zsh-autosuggestions installed"
fi

# zsh-completions
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions ]; then
    git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
    success "zsh-completions installed"
fi

# zsh-nvm
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm ]; then
    git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:~/.oh-my-zsh/custom}/plugins/zsh-nvm
fi

# tpm
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    success "tpm installed"
fi

# spacevim
if [ ! -d ~/.SpaceVim ]; then
    sudo apt-get -qqy install software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get -qqy install neovim wamerican
    curl -sLf https://spacevim.org/install.sh | bash
    success "spacevim installed"
fi

# pyenv
if [ ! -d ~/.pyenv ]; then
    curl https://pyenv.run | bash
    success "pyenv installed"
fi

# set pyenv path temporary
if [[ $PATH != *"/root/.pyenv/bin"* ]]; then
    export PATH="/root/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# python 3.7.0
if [[ $(pyenv versions) != *"3.7.0"* ]]; then
    sudo apt-get -qqy install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev
    pyenv install 3.7.0
    pyenv global 3.7.0
    success "python 3.7.0 installed"
fi

# fuck
pip install thefuck
success "fuck installed"

# spacevim python layer
pip install flake8 yapf autoflake isort
success "spacevim python layer dependency installed"

# copy all file
cp .zshrc .tmux.conf .tmux.conf.local ~
success "copy custom config file to $HOME"

# change default shell to zsh
if [[ $SHELL != *"zsh"* ]]; then
    chsh -s $(which zsh)
    success "change default shell to zsh"
fi

info "what you should do manually:"
info "1) copy spacevim config manually \e[1mafter running vim\e[0m: \e[35mcp init.toml ~/.SpaceVim.d/\e[0m"
info "2) login again to use zsh"
info "3) if you got 'command not found: print_icon', run the command: \e[35mlocale-gen --lang en_US.UTF-8\e[0m"
info "4) install node: \e[35mnvm install node\e[0m"
