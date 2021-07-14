
# looking for Step definitions
fsteps() {
  grep -e "\(Given\|Then\|When\)" features/step_definitions/**/* | fzf
}
