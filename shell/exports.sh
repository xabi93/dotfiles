# ------------------------------------------------------------------------------
# Languages
# ------------------------------------------------------------------------------
export GOPATH="$HOME/go"
export GOBIN=$HOME/go/bin

# ------------------------------------------------------------------------------
# Path - The higher it is, the more priority it has
# ------------------------------------------------------------------------------
export path=(
  "$HOME/bin"
  "$GOPATH/bin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/bin"
  "/usr/bin"
  "/usr/sbin"
  "/sbin"
)
