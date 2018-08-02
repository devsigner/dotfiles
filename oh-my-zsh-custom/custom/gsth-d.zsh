# Git stash drop given stash num
gsth-d() {
  git stash drop "stash@{$@}"
}
