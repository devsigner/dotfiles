--WIP--

Requirements
------------

Homebrew:
========

http://brew.sh/index_fr.html

install brew:

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

ADSF: Version management:
-------------------------

https://github.com/asdf-vm/asdf#setup

- required for building Ruby <= 1.9.3-p0:
brew tap homebrew/dupes && brew install apple-gcc42

- Some dependences
brew install coreutils automake autoconf openssl libyaml readline libxslt libtool unixodbc

install:
  cd ~
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0

  # bash
  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile

  # zsh
  echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
  echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

  # fish
  echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
  mkdir -p ~/.config/fish/completions; and cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions<Paste>

Shell
-----

* ZSH
  Load oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

* Fish
  load fish from homebrew
    brew install fish --HEAD
  
  add the shell to the system know shells: 
    echo /usr/local/bin/fish | sudo tee -a /etc/shells

  make fish your default shell:
    chsh -s /usr/local/bin/fish

  More details and help:
  https://github.com/ellerbrock/fish-shell-setup-osx

Some tools:
----------

    brew update
    brew tap thoughtbot/formulae
    brew tap homebrew/services

Unix
----

    brew install gnu-sed
    brew install ctags
    brew install wget
    brew install git
    brew install openssl
    brew install rcm
    brew install reattach-to-user-namespace
    brew install neovim
    brew install v
    brew install zsh
    brew install ack
    brew install phantomjs

fzf
---
https://github.com/junegunn/fzf

-- With Homebrew:

    brew install fzf
    /usr/local/opt/fzf/install    

Then Set .vimrc

    set rtp+=/usr/local/opt/fzf

-- Or with Vim Plug:

    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Then Set .vimrc

    set rtp+=~/.fzf

GitHub
------

    brew install hub
    brew install gitsh

Image manipulation
------------------

    brew install imagemagick

Testing
-------

    brew install qt

Programming languages
---------------------

    # should come after openssl
    brew install libyaml
    brew install ruby-build
    asdf plugin-add node
    asdf plugin-add ruby 2.2.1

Databases
---------

    brew install postgres
    brew services start postgres
    
    brew install mysql
    brew services start mysql
    
    brew install redis
    brew services start redis
