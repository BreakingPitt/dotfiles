#!/bin/bash

set -o errexit
set -o pipefail

# Configuration Variables
BREWFILE="./Brewfile"

_detect_brew() {
  if ! command -v brew &> /dev/null; then
    return 1
  else
    return 0
  fi
}

_detect_os() {
  declare -r OS_NAME="$(uname -s)"
  local OS=""

  case "$OS_NAME" in
      "Darwin")
          OS="osx"
          ;;
      "Linux")
          OS="linux"
          ;;
      *)
          OS="unknown"
          ;;
  esac

  printf "%s" "$OS"
}

_display_beer() {
  echo "🍺 $1"
}

_display_finish() {
  echo "🎉 $1"
  echo " "
}

_display_install() {
  echo "⚙️  $1"
}

_display_key() {
  echo "🔑 $1"
}

_display_start() {
  echo "🏁 $1"
  echo " "
}

_display_success() {
  success=true
  echo "✅ $1"
}

_display_unsupported() {
  success=false
  echo "❌ $1"
}

_get_sudo_password() {
  _display_key "Enter your sudo password:"
  read -s PASSWORD
  if [ -z "$PASSWORD" ]; then
    _display_unsupported "Sudo password is empty. Aborting."
  fi


_install_homebrew() {
   if _detect_brew; then
     _display_success "Homebrew is already installed."
   else
     local OS
     OS="$(detect_operating_system)"

     case "$OS" in
       "osx")
         _display_install "Installing Homebrew for macOS..."
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
         ;;
       "linux")
         _display_install "Installing Homebrew for Linux..."
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
         ;;
       *)
         _display_unsupported "Unsupported operating system: $OS. Homebrew installation aborted."
         return
         ;;
     esac
     if _install_homebrew; then
       _display_success "Homebrew has been successfully installed."
     else
       _display_unsupported "Failed to install Homebrew."
     fi
   fi
}

_install_oh_my_zsh() {
  if ! command -v omz &> /dev/null; then
    _display_install "Installing Oh My Zsh..."
    if output=$( /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"  2>&1); then
       _display_success "Oh My Zsh installation completed successfully."  
    else
      _display_unsupported "Oh My Zsh installation failed."
    fi
  else
    _display_success "Oh My Zsh is already installed."
  fi
}

_install_packages_from_brewfile() {
  local BREWFILE="$1"
  local PASSWORD="$2"

  if [ -f "$BREWFILE" ]; then
    # Run brew bundle and capture its output
    bundle_output=$(echo "$PASSWORD" |brew bundle --file="$BREWFILE" 2>&1)

    # Check if brew bundle was successful
    if [ $? -eq 0 ]; then
      _display_success "Brewfile packages installation completed successfully."

      # Parse the captured output to extract installed package names
      while IFS= read -r line; do
        if [[ "$line" == "Installing"* ]]; then
          package_name="${line#Installing }"
          _display_success "$package_name Installed successfully"
        fi
      done <<< "$bundle_output"
    else
      _display_unsupported "Error during Brewfile installation. See the output below for details:"
    fi
  else
    _display_unsupported "Brewfile not found: $BREWFILE"
  fi
}


_install_xcode_command_line_tools() {
  if ! xcode-select -p &> /dev/null; then
    _display_start "Xcode Command Line Tools are not installed. Installing..."
    if xcode-select --install &> /dev/null; then
      _display_success "Xcode Command Line Tools installation started. Follow the on-screen prompts to complete the installation."
    else
      _display_unsupported "❌ Failed to initiate Xcode Command Line Tools installation."
    fi
  else
    _display_success "Xcode Command Line Tools are already installed."
  fi
}


_display_start "Starting installation process..."
_get_sudo_password
_install_xcode_command_line_tools
_install_homebrew
_install_packages_from_brewfile  "$BREWFILE" "$PASSWORD"
_install_oh_my_zsh

if [ "$success" = true ]; then
  _display_finish "Installation finished!"
else
  _display_unsupported "Installation finished with errors."
fi

