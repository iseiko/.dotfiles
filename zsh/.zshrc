fastfetch
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Load modules
source ~/.config/zsh/aliases
source ~/.config/zsh/completions
source ~/.config/zsh/envs
source ~/.config/zsh/hist
source ~/.config/zsh/keybinds
source ~/.config/zsh/plugins
