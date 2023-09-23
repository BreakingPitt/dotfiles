#!/bin/zsh

set -o errexit
set -o pipefail

BREWFILE="./Brewfile"
DOTFILES=(".ansible.cfg"
          ".aws/config:.aws"
          ".curlrc" 
          ".gitattributes" 
          ".gitconfig" 
          ".gitconfig-personal" 
          ".gitconfig-work" 
          ".gitignore-global"
          ".pylintrc"
          ".screenrc"
          ".ssh/config:.ssh"
          ".wgetrc")
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
}

_display_install() {
  echo "⚙️  $1"
}

_display_key() {
  echo "🔑 $1"
}

_display_start() {
  echo "🏁 $1"
}

_display_success() {
  success=true
  echo -e "\t✅ $1"
}

_display_unsupported() {
  success=false
  echo -e "\t❌ $1"
}

_display_success_no_indent() {
  success=true
  echo "✅ $1"
}

_display_unsupported_no_indent() {
  success=false
  echo "❌ $1"
}

_get_sudo_password() {
  _display_key "Enter your sudo password:"
  read -s -r PASSWORD
  if [ -z "$PASSWORD" ]; then
    _display_unsupported "Sudo password is empty. Aborting."
  fi
}

_homebrew_update() {
   _display_start "Homebrew update process started..."
   if brew update  > /dev/null; then
     _display_success "Homebrew update process run successfully."
     _display_finish  "Homebrew update process finished!"
   else
     _display_unsupported "There was an error updating Homebrew."
   fi
}

_homebrew_upgrade() {
   _display_start "Homebrew upgrade process started..."
   if brew upgrade  > /dev/null; then
     _display_success "Homebrew updgrade process run successfully."
     _display_finish  "Homebrew updgrade process finished!"
   else
     _display_unsupported "There was an error updgrading Homebrew."
   fi
}

_homebrew_install() {
   if _detect_brew; then
     _display_success "Homebrew is already installed."
   else
     local OS
     OS="$(detect_operating_system)"

     case "$OS" in
       "osx")
         _display_install "Installing Homebrew for macOS..."
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
         return
         ;;
       "linux")
         _display_install "Installing Homebrew for Linux..."
         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
         return
	 ;;
       *)
         _display_unsupported "Unsupported operating system: $OS. Homebrew installation aborted."
         return
         ;;
     esac

     if ! _install_homebrew; then
       _display_unsupported "Failed to install Homebrew."
       return
     fi
   fi
}

_install_oh_my_zsh() {
  if ! command -v omz &> /dev/null; then
    _display_install "Installing Oh My Zsh..."
    if output=$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh 2>&1); then
      if /bin/bash -c "$output"; then
        _display_success "Oh My Zsh installation completed successfully."
      else
        _display_unsupported "Oh My Zsh installation failed."
      fi
    else
      _display_unsupported "Failed to fetch the Oh My Zsh installation script."
    fi
  else
    _display_success "Oh My Zsh is already installed."
  fi
}

_install_packages_from_brewfile() {
  local BREWFILE="$1"
  local PASSWORD="$2"

  if [ -f "$BREWFILE" ]; then
    _display_start "Brewfile package installing proccess started..."
    bundle_output=$(echo "$PASSWORD" |brew bundle --file="$BREWFILE")

    # Check if brew bundle was successful
    if [ $? -eq 0 ]; then
      _display_success "Brewfile package installing proccess run successfully!"

      while IFS= read -r line; do
        if [[ "$line" == "Installing"* ]]; then
          package_name="${line#Installing }"
          _display_success "$package_name Installed successfully"
        fi
      done <<< "$bundle_output"
      _display_finish  "Homebrew update process finished!"
    else
      _display_unsupported "Error during Brewfile installation. See the output below for details:"
      return
    fi
  else
    _display_unsupported "Brewfile not found: $BREWFILE"
    return
  fi
}


_install_xcode_command_line_tools() {
  if ! xcode-select -p &> /dev/null; then
    _display_start "Xcode Command Line Tools are not installed. Installing..."
    if xcode-select --install &> /dev/null; then
      _display_success "Xcode Command Line Tools installation started. Follow the on-screen prompts to complete the installation."
      return
    else
      _display_unsupported "❌ Failed to initiate Xcode Command Line Tools installation."
      return
    fi
  else
    _display_success "Xcode Command Line Tools are already installed."
    return
  fi
}

_set_up_dot_files() {
  _display_start "Dotfiles configuration process started..."

  errors=()

  for dotfile in "${DOTFILES[@]}"; do
    IFS=":" read -r NAME SUBDIR <<< "$dotfile"
    SUBDIR="${SUBDIR:-}"
    mkdir -p "$HOME/$SUBDIR"

    if ln -sfn "$DOTFILES_DIR/$NAME" "$HOME/$NAME"; then
      _display_success "Symbolic link for $NAME created."
    else
      errors+=("Failed to create symbolic link for $NAME.")
    fi
  done

  if [ ${#errors[@]} -eq 0 ]; then
    _display_finish "Dotfiles configuration process completed!"
  else
    _display_unsupported "Dotfiles installation completed with the following errors:"
    for error in "${errors[@]}"; do
      _display_unsupported "  - $error"
    done
  fi
}

_get_sudo_password
_display_start "Bootstrap process started..."
_install_xcode_command_line_tools
_homebrew_install
_homebrew_update
_homebrew_upgrade
_install_packages_from_brewfile  "$BREWFILE" "$PASSWORD"
#_install_oh_my_zsh

if [ "$success" = true ]; then
  _display_finish "Bootstrap process finisehd successfully!"
else
  _display_unsupported_no_indent "Bootstrap process finished with errors!"
fi

_set_up_dot_files


