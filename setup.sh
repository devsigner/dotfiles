#!/bin/sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n$fmt\\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\\n" "$text" >> "$zshrc"
    else
      printf "\\n%s\\n" "$text" >> "$zshrc"
    fi
  fi
}

# shellcheck disable=SC2154
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ ! -d "$HOME/.bin/" ]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

# shellcheck disable=SC2016
append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

HOMEBREW_PREFIX="/usr/local"

if [ -d "$HOMEBREW_PREFIX" ]; then
  if ! [ -r "$HOMEBREW_PREFIX" ]; then
    sudo chown -R "$LOGNAME:admin" /usr/local
  fi
else
  sudo mkdir "$HOMEBREW_PREFIX"
  sudo chflags norestricted "$HOMEBREW_PREFIX"
  sudo chown -R "$LOGNAME:admin" "$HOMEBREW_PREFIX"
fi

update_shell() {
  local shell_path;
  shell_path="$(command -v zsh)"

  fancy_echo "Changing your shell to zsh ..."
  if ! grep "$shell_path" /etc/shells > /dev/null 2>&1 ; then
    fancy_echo "Adding '$shell_path' to /etc/shells"
    sudo sh -c "echo $shell_path >> /etc/shells"
  fi
  sudo chsh -s "$shell_path" "$USER"
}

case "$SHELL" in
  */zsh)
    if [ "$(command -v zsh)" != '/usr/local/bin/zsh' ] ; then
      update_shell
    fi
    ;;
  *)
    update_shell
    ;;
esac

fancy_echo "Install oh my ZSH"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

fancy_echo "Set zsh theme"
rm -R ~/.oh-my-zsh/custom/themes
ln -s ~/.dotfiles/oh-my-zsh-custom/custom/themes ~/.oh-my-zsh/custom/themes
rm -R ~/.oh-my-zsh/custom/plugins
ln -s ~/.dotfiles/oh-my-zsh-custom/custom/plugins ~/.oh-my-zsh/custom/plugins
ln -s ~/.dotfiles/oh-my-zsh-custom/custom/*.zsh ~/.oh-my-zsh/custom/

fancy_echo "Symlinc rc files"
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/ackrc ~/.ackrc
ln -s ~/.dotfiles/pryrc ~/.pryrc
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/gitignore ~/.gitignore

gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    gem update "$@"
  else
    gem install "$@"
  fi
}

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew ..."
    curl -fsS \
      'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby

    append_to_zshrc '# recommended by brew doctor'

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
fi

if brew list | grep -Fq brew-cask; then
  fancy_echo "Uninstalling old Homebrew-Cask ..."
  brew uninstall --force brew-cask
fi

fancy_echo "Updating Homebrew formulae ..."
brew update --force # https://github.com/Homebrew/brew/issues/1151
brew bundle --file=- <<EOF
cask_args appdir: "/Applications"

tap "thoughtbot/formulae"
tap "homebrew/cask"
tap "universal-ctags/universal-ctags"
tap "caskroom/cask"

# Unix
brew "universal-ctags", args: ["HEAD"]
brew "gnu-sed"
brew "ranger"
brew "git"
brew "openssl"
brew "rcm"
brew "ack"
brew "fzf"
brew "neovim"
brew "zsh"

# Mac App Store
brew "mas"

# GitHub
brew "hub"

# Image manipulation
brew "imagemagick"

# Testing
brew "qt@5.5" if MacOS::Xcode.installed?

# Programming language prerequisites and package managers
brew "libyaml" # should come after openssl
brew "coreutils"
brew "yarn"
cask "gpg-suite"
brew "z"
brew "fzf"
brew "ripgrep"

# Applications
cask "google-chrome"
cask "firefox"
cask "iterm2"
cask "launchbar"

# Some fonts
cask homebrew/cask-fonts/font-consolas-for-powerline
cask homebrew/cask-fonts/font-menlo-for-powerline
cask homebrew/cask-fonts/font-roboto-mono-for-powerline
cask homebrew/cask-fonts/font-menlo-for-powerline

# Databases
#brew "postgres", restart_service: :changed
#brew "redis", restart_service: :changed
EOF

if brew list | grep --silent "qt@5.5"; then
  fancy_echo "Symlink qmake binary to /usr/local/bin for Capybara Webkit..."
  brew unlink qt@5.5
  brew link --force qt@5.5
fi

fancy_echo "Configuring asdf version manager..."
if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.5.0
  append_to_zshrc "source $HOME/.asdf/asdf.sh" 1
fi

install_asdf_plugin() {
  local name="$1"
  local url="$2"

  if ! asdf plugin-list | grep -Fq "$name"; then
    asdf plugin-add "$name" "$url"
  fi
}

# shellcheck disable=SC1090
source "$HOME/.asdf/asdf.sh"
install_asdf_plugin "ruby" "https://github.com/asdf-vm/asdf-ruby.git"
install_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

install_asdf_language() {
  local language="$1"
  local version
  version="$(asdf list-all "$language" | grep -v "[a-z]" | tail -1)"

  if ! asdf list "$language" | grep -Fq "$version"; then
    asdf install "$language" "$version"
    asdf global "$language" "$version"
  fi
}

fancy_echo "Installing latest Ruby..."
install_asdf_language "ruby"
gem update --system
gem_install_or_update "bundler"
number_of_cores=$(sysctl -n hw.ncpu)
bundle config --global jobs $((number_of_cores - 1))

fancy_echo "Installing latest Node..."
bash "$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
install_asdf_language "nodejs"

fancy_echo "Install some apps from AppStore"

# 1Password
mas install 443987910
# Magnet
mas install 441258766
# Affinity Photo
mas install 824183456
# Affinity Designer
mas install 824171161
# HTTP Client
mas install 418138339

# if [ -f "$HOME/.laptop.local" ]; then
#   fancy_echo "Running your customizations from ~/.laptop.local ..."
#   # shellcheck disable=SC1090
#   . "$HOME/.laptop.local"
# fi
