alias agmt='jump agmt'
alias j='jump'

# Bundle
alias b="bundle"
alias be="bundle exec"
alias bi="bundle install"
alias bo="bundle open"

# Rails
alias rs="rails s -b 0.0.0.0"
alias rc="rails c"

# Spring
alias ss="spring stop"

alias magit="vim -c MagitOnly"

## brew install ack
## brew install gnu-sed --default-names
function ack-sed () {
  ack $1 -l --print0 | xargs -0 -n 1 sed -i "s/$1/$2/g";
}

function pman () {
    if man -w $@ > /dev/null
    then
      man -t $@ | ps2pdf - | open -f -a Preview
    fi
}

# Simple shortcut with "good" options for sshfs
mount-sshfs () {
  sshfs $@ -o rdonly,noatime,nobrowse,reconnect,compression=yes
}

# (re-)mount secrets config files, _run inside repository's root_
function augment-mount-config () {
  if mount -t osxfusefs | grep config/secrets > /dev/null; then
    umount config/secrets
    sleep 0.1 # umount is not immediate and can prevent following mkdir to work correctly.
  fi
  mkdir -p config/secrets
  mount-sshfs puppet.augmentedev.com:web-app/secrets config/secrets
}
