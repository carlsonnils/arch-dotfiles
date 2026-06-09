#!/usr/bin/env bash
# =============================================================================
# Dotfiles Deploy Script
# Symlinks all configs into ~/.config
# Run from the dotfiles directory: ./deploy.sh
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}${BOLD}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${NC} $*"; }
error()   { echo -e "${RED}${BOLD}[ERR]${NC}  $*"; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

link() {
    local src="$DOTFILES_DIR/$1"
    local dst="$CONFIG_DIR/$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        warn "Backing up existing $dst → $dst.bak"
        mv "$dst" "$dst.bak"
    fi

    # ln -sfn "$src" "$dst"
    # success "Linked $1 → $dst"
    mkdir -p dst
    cp -r src/* dst
    success "Copied $src -> $dst"
}

echo ""
echo -e "${BOLD}============================================================${NC}"
echo -e "${BOLD} Dotfiles Deploy${NC}"
echo -e "${BOLD}============================================================${NC}"
echo ""

info "Dotfiles source: $DOTFILES_DIR"
info "Config target:   $CONFIG_DIR"
echo ""

# --- Symlink each config -----------------------------------------------------
link hyprland    hypr
link waybar      waybar
link hyprlock    hyprlock
link hypridle    hypridle
link hyprpaper   hyprpaper
link alacritty   alacritty
link mako        mako
link yazi        yazi

# --- Wallpaper placeholder ---------------------------------------------------
WALLPAPER_DIR="$CONFIG_DIR/hyprpaper"
if [ ! -f "$WALLPAPER_DIR/wallpaper.jpg" ]; then
    warn "No wallpaper found at $WALLPAPER_DIR/wallpaper.jpg"
    echo -e "     Drop a 2560x1440 wallpaper there and name it ${YELLOW}wallpaper.jpg${NC}"
    echo -e "     Kanagawa-style suggestion: https://github.com/rebelot/kanagawa.nvim"
fi

echo ""
echo -e "${BOLD}============================================================${NC}"
echo -e "${GREEN}${BOLD} All configs deployed!${NC}"
echo -e "${BOLD}============================================================${NC}"
echo ""
echo -e "  Start Hyprland by logging into TTY1."
echo ""
