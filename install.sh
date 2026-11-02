#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_TAG="$(date +%Y%m%d-%H%M%S)"
SKIP_APPS=false
SKIP_NVIM=false
FIREFOX_PROFILE=""

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --skip-apps                 Do not install Homebrew packages or applications
  --skip-nvim                 Do not clone the separate Neovim configuration
  --firefox-profile PATH      Use a specific Firefox profile directory
  -h, --help                  Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-apps)
      SKIP_APPS=true
      ;;
    --skip-nvim)
      SKIP_NVIM=true
      ;;
    --firefox-profile)
      [[ $# -ge 2 ]] || { echo "Missing path after --firefox-profile" >&2; exit 1; }
      FIREFOX_PROFILE="$2"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This setup targets macOS." >&2
  exit 1
fi

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  printf 'Homebrew is required to install the apps. Install it now? [y/N] '
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Homebrew installation declined. Re-run with --skip-apps to install only configs." >&2
    exit 1
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

backup_and_link() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    echo "Already linked: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.backup-${BACKUP_TAG}"
    mv "$target" "$backup"
    echo "Backed up: $target -> $backup"
  fi

  ln -s "$source" "$target"
  echo "Linked: $target -> $source"
}

find_firefox_profile() {
  local firefox_root="$HOME/Library/Application Support/Firefox"
  local profile=""

  if [[ -n "$FIREFOX_PROFILE" ]]; then
    mkdir -p "$FIREFOX_PROFILE"
    printf '%s\n' "$FIREFOX_PROFILE"
    return
  fi

  if [[ -d "$firefox_root/Profiles" ]]; then
    profile="$(find "$firefox_root/Profiles" -maxdepth 1 -type d -name '*.default-release' -print -quit)"
    if [[ -z "$profile" ]]; then
      profile="$(find "$firefox_root/Profiles" -maxdepth 1 -type d -name '*.default*' -print -quit)"
    fi
  fi

  if [[ -z "$profile" && -x /Applications/Firefox.app/Contents/MacOS/firefox ]]; then
    /Applications/Firefox.app/Contents/MacOS/firefox -CreateProfile default-release >/dev/null 2>&1 || true
    profile="$(find "$firefox_root/Profiles" -maxdepth 1 -type d -name '*.default-release' -print -quit 2>/dev/null || true)"
  fi

  if [[ -z "$profile" ]]; then
    echo "Could not find or create a Firefox profile. Open Firefox once, then rerun this installer." >&2
    exit 1
  fi

  printf '%s\n' "$profile"
}

if [[ "$SKIP_APPS" == false ]]; then
  install_homebrew
  brew bundle --file "$DOTFILES_DIR/Brewfile"
fi

backup_and_link "$DOTFILES_DIR/aerospace" "$HOME/.config/aerospace"
backup_and_link "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
backup_and_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

firefox_profile="$(find_firefox_profile)"
backup_and_link "$DOTFILES_DIR/firefox/chrome" "$firefox_profile/chrome"
backup_and_link "$DOTFILES_DIR/firefox/user.js" "$firefox_profile/user.js"

if [[ "$SKIP_NVIM" == false ]]; then
  if [[ ! -e "$HOME/.config/nvim" ]]; then
    git clone https://github.com/nagendraallam/nvim.git "$HOME/.config/nvim"
  else
    echo "Keeping existing Neovim config: $HOME/.config/nvim"
  fi
fi

if command -v aerospace >/dev/null 2>&1; then
  aerospace reload-config >/dev/null 2>&1 || true
fi

if command -v tmux >/dev/null 2>&1 && tmux has-session 2>/dev/null; then
  tmux source-file "$HOME/.tmux.conf" || true
fi

echo
echo "Setup complete. Fully restart Firefox and Ghostty to load their new configuration."
