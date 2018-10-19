# Fuzzy-find and checkout a branch
function gco {
  # all branch     | path         |                   | split by /     | take 2 last | join line with /            | checkout
  git branch --all | grep -v HEAD | string trim | fzf | sed 's/\//\n/g' | tail -n 2 | sed -e :a  -e 'N;s/\n/\//;ta' | xargs git checkout
}
