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
