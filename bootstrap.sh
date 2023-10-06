#!/bin/bash

set -o errexit
set -o pipefail

# Define script-level variables
BREWFILE="./Brewfile"
DOTFILES=(".aliases"
          ".ansible.cfg"
          ".aws/config:.aws"
          ".curlrc"
          ".functions"
          ".gitattributes"
          ".gitconfig"
          ".gitconfig-personal"
          ".gitconfig-work"
          ".gitignore-global"
          ".gnupg/gpg-agent.conf:.gnupg"
          ".gnupg/gpg.conf:.gnupg"
          ".pylintrc"
          ".screenrc"
          ".ssh/config:.ssh"
          ".wgetrc")
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper function to detect if Homebrew is installed
_detect_brew() {
  command -v brew &> /dev/null
}

# Helper function to detect the operating system
_detect_os() {
  case "$(uname -s)" in
    "Darwin") echo "osx" ;;
    "Linux") echo "linux" ;;
    *) echo "unknown" ;;
  esac
}

_display_message() {
  local message="$1"
  local in_progress="$2"
  local success="$3"
  local num_tabs="$4"

  local color_start="\033[0;37m"  # White color
  local color_end="\033[0m"  # Reset color

  local indentation=""
  for ((i = 0; i < num_tabs; i++)); do
    indentation+="\t"  # Add tabs based on the provided number
  done

  if [ "$in_progress" = true ]; then
    indentation+="\t"  # Add one additional tab for in-progress messages
  elif [ "$success" = true ]; then
    indentation+="\t"  # Add one additional tab for regular success messages
  fi

  if [ "$success" = false ]; then
    local status="[KO]"
    local status_color="\033[0;31m"  # Red color for failure
  else
    local status="[OK]"
    local status_color="\033[0;32m"  # Green color for success
  fi

  echo -e "${color_start}${indentation}$message ${status_color}$status${color_end}"
}

_get_sudo_password() {
  local password_required=false
  local OS

  OS="$(_detect_os)"

  if [ "$OS" = "osx" ]; then
    password_required=true
  fi

  if [ "$password_required" = true ]; then
    echo "Enter your sudo password:"
    read -s -r PASSWORD
    if [ -z "$PASSWORD" ]; then
      echo "Sudo password is empty... Aborting."
      exit 1
    fi
  fi
}

_homebrew_clean_up() {
  if brew cleanup > /dev/null 2>&1; then
    _display_message "HomeBrew cleanup completed successfully." false true 1
  else
    _display_message "Error during HomeBrew cleanup." false true 1
  fi
}

_homebrew_update() {
  if brew update > /dev/null 2>&1; then
    _display_message "HomeBrew update completed successfully." false true 1
  else
    _display_message "Error updating HomeBrew." false true 1
  fi
}

_homebrew_upgrade() {
  if brew upgrade > /dev/null 2>&1; then
    _display_message "HomeBrew upgrade completed successfully." false true 1
  else
    _display_message "Error upgrading HomeBrew packages." false true 1
  fi
}

_homebrew_install() {
  if _detect_brew; then
    _display_message "HomeBrew is already installed." false true 2
  else
    local OS
    OS="$(_detect_os)"
    local install_message

    case "$OS" in
      "osx")
        install_message="Installing HomeBrew for macOS..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ;;
      "linux")
        install_message="Installing HomeBrew for Linux..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
        ;;
      *)
        _display_message "Unsupported operating system: $OS. HomeBrew installation aborted." false true 2
        exit 1
        ;;
    esac

    if ! _detect_brew; then
      _display_message "Failed to install HomeBrew." false true 2
      exit 1
    fi

    _display_message "$install_message" false true 1
  fi
}

_install_oh_my_zsh() {
  if command -v omz &> /dev/null; then
    _display_message "Oh My Zsh is already installed." false true 2
    return
  fi

  _display_message "Installing Oh My Zsh..." false true 1
  local install_script_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

  sh -c "$(curl -fsSL "$install_script_url")" "" --unattended

  if [ $? -eq 0 ]; then
    _display_message "Oh My Zsh installation completed successfully." false true 1
  else
    _display_message "Oh My Zsh installation failed." false true 1
  fi
}

_install_packages_from_brewfile() {
  local BREWFILE="$1"
  local PASSWORD="$2"

  if [ -f "$BREWFILE" ]; then
    bundle_output=$(echo "$PASSWORD" | brew bundle --file="$BREWFILE" --verbose)

    if [ $? -eq 0 ]; then
      while IFS= read -r line; do
        if [[ "$line" == "Installing"* ]]; then
          package_name="${line#Installing }"
          _display_message "$package_name installed successfully." false true 1
        fi
      done <<< "$bundle_output"

      _display_message "Brewfile packages installation completed successfully!" false true 2
    else
      _display_message "Error during Brewfile installation. See the output below for details:" false true 2
      echo "$bundle_output"
    fi
  else
    _display_message "Brewfile not found: $BREWFILE" false true 2
  fi
}

_install_xcode_command_line_tools() {
  if ! (xcode-select -p > /dev/null 2>&1); then
    _display_message "Installing Xcode Command Line Tools..." true true 1
    if (xcode-select --install > /dev/null 2>&1); then
      _display_message "Xcode Command Line Tools installed successfully." false true 1
    else
      _display_message "Failed to initiate Xcode Command Line Tools installation." false false 1
      exit 1
    fi
  else
    _display_message "Xcode Command Line Tools are already installed." false true 1
  fi
}

_install_macos_updates() {
  local PASSWORD="$1"
  local OS
  OS="$(_detect_os)"

  if [ "$OS" = "osx" ]; then
    software_update_output=$(echo "$PASSWORD" | sudo -S softwareupdate -i -a > /dev/null 2>&1)
    if [ $? -eq 0 ]; then
      _display_message "macOS Software updates completed successfully." false true 1
    else
      _display_message "Error running macOS software updates." false true 1
    fi
  else
    _display_message "Software updates are only supported on macOS." false true 1
  fi
}

_set_up_dot_files() {
  errors=()

  for dotfile in "${DOTFILES[@]}"; do
    IFS=":" read -r NAME SUBDIR <<< "$dotfile"
    SUBDIR="${SUBDIR:-}"
    mkdir -p "$HOME/$SUBDIR"

    if ln -sfn "$DOTFILES_DIR/$NAME" "$HOME/$NAME"; then
      _display_message "Symbolic link for $NAME created." false true 1
    else
      errors+=("Failed to create symbolic link for $NAME.")
    fi
  done

  if [ ${#errors[@]} -ne 0 ]; then
    _display_message "Dotfiles installation completed with the following errors:" false true 1
    for error in "${errors[@]}"; do
      _display_message "- $error" false true 1
    done
  else
    _display_message "Dotfiles installation completed successfully!" false true 0
  fi
}

_bootstrap_process() {

  local xcode_tools_checked=false

  _display_message "Pre-flight checks processes started..." true true 0

  if ! (xcode-select -p > /dev/null 2>&1); then
    _display_message "Installing Xcode Command Line Tools..." true true 1
    if (xcode-select --install > /dev/null 2>&1); then
      _display_message "Xcode Command Line Tools installed successfully." false true 1
    else
      _display_message "Failed to initiate Xcode Command Line Tools installation." false false 1
      return 1
    fi
    xcode_tools_checked=true
  else
    _display_message "Xcode Command Line Tools are already installed." false true 1
  fi

  if _detect_brew; then
    _display_message "HomeBrew is already installed." false true 1
  else
    if _homebrew_install; then
      _display_message "HomeBrew installed successfully." false true 1
    else
      _display_message "Error installing HomeBrew." false false 1
      return 1
    fi
  fi

  _display_message "HomeBrew maintenance process started..." true true 0
  _homebrew_update
  _homebrew_upgrade
  _homebrew_clean_up

  if [ "$xcode_tools_checked" = true ]; then
    _display_message "HomeBrew package install process started..." true true 0
    _install_packages_from_brewfile "$BREWFILE" "$PASSWORD"
  fi

  #if ! command -v omz &> /dev/null; then
  #  _install_oh_my_zsh
  #else
  #  _display_message "Oh My Zsh is already installed." false true 1
  #fi

  _display_message "Setting up dotfiles process started..." true true 0
  _set_up_dot_files

  _display_message "Setting up mac OS preferences process started..." true true 0
  source ./macos.sh
  _display_message "Setting up mac OS preferences process finished succesfully..." true true 0
}

_get_sudo_password

echo -e "--- Bootstrap Process ---"

_bootstrap_process

echo -e "--- Bootstrap Process Completed Successfully ---"

