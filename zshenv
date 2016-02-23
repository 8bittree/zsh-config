# Sourced by all instances of Zsh. Sets environment variables

# Set up the path array to keep entries unique and in the leftmost entered
# position.
typeset -U path

if [[ -a "~/.zshenv_local" ]]; then
	source "~/.zshenv_local"
fi
