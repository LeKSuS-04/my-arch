if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Set $PATH variable
set -gx PATH $HOME/.local/bin $PATH     # Local binaries
set -gx PATH $HOME/.cabal/bin $PATH     # Cabal packages
set -gx PATH $HOME/.ghcup/bin $PATH     # Haskell toolchain
set -gx PATH $HOME/.cargo/bin $PATH     # Rust cargo

# Aliases
# General
alias py="python3"
alias unimatrix="unimatrix -n -s 97 -l o -f -a -c green"
alias l="ls"
# Git
alias gaa="git add --all"
alias gc="git commit"
alias gp="git push"
alias gs="git status"
alias gl="git log"