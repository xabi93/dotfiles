if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
##### WHAT YOU WANT TO DISABLE FOR WARP - BELOW

  #### FIG ENV VARIABLES ####
  [ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
  ### END FIG ENV VARIABLES ####

##### WHAT YOU WANT TO DISABLE FOR WARP - ABOVE
fi

source $(brew --prefix)/opt/antigen/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle git
antigen bundle osx
antigen bundle golang
antigen bundle kubectl
antigen bundle terraform
antigen bundle aws
antigen bundle gcloud
antigen bundle command-not-found

antigen apply

autoload -U add-zsh-hook

# ZSH Ops
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FCNTL_LOCK
setopt +o nomatch
# setopt autopushd

# Async mode for autocompletion
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

source "$DOTFILES_PATH/shell/init.sh"


source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"


eval "$(fnm env)"

# place default node version under $HOME/.node-version
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]] || [[ -f .node-version && -r .node-version ]]; then
    fnm use
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
fi

eval "$(starship init zsh)"
