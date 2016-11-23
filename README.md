--WIP--

Requirements
------------

Load oh-my-zsh

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


Homebrew:
========

http://brew.sh/index_fr.html

install brew:

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


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
    brew install macvim
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
    brew install node
    brew install rbenv
    brew install ruby-build

Databases
---------

    brew install postgres
    brew services start postgres
    
    brew install mysql
    brew services start mysql
    
    brew install redis
    brew services start redis

