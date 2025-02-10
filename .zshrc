
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the LC_ALL environment variable to en_US.UTF-8 for locale settings.
export LC_ALL=en_US.UTF-8

# Set the LANG environment variable to en_US.UTF-8 for language settings.
export LANG=en_US.UTF-8

# Sets the GPG_TTY environment variable to use the current terminal for GPG interaction.
export GPG_TTY=$(tty)

# Limit the number of commands kept in memory to 10,000.
HISTSIZE=10000

# Set the maximum number of commands to store in the history file to 100,000.
SAVEHIST=100000

# Define the file location for saving the Zsh history.
HISTFILE="$HOME/.zsh_history"

# Ignore duplicate commands, but keep the last occurrence.
setopt histignorealldups

# Share the command history across all open Zsh sessions.
setopt sharehistory

# Automatically change directories when a directory name is typed as a command.
setopt autocd

# Allow prompt substitution, required for Git plugin to display branch info.
setopt promptsubst

# Auto update oh-my-zsh.
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 1

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# ZSH plugins.
plugins=(git git-prompt zsh-bat)

# ZSH theme.
ZSH_THEME="dracula"

# Load oh-my-zsh.
source $ZSH/oh-my-zsh.sh

# Load the fuck.
eval $(thefuck --alias)

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# Load ZSH auto suggestions.
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Load ZSH syntax highlighting.
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load aliases from a separate file
if [[ -f ~/.zsh_aliases ]]; then
  source ~/.zsh_aliases
fi
