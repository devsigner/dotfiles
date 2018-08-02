# Open man on pdf preview
pman() {
  if [ man -w $argv > /dev/null ]
  then
    man -t $argv | ps2pdf - | open -f -a Preview
  fi
}
