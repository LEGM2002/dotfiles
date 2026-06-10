#!/usr/bin/env bash
# by LEGM2002

set -e

DOTFILES="$HOME/dotfiles"
CONFIG="$HOME/.config"
BASHRC="$HOME/.bashrc"

echo "Installing dotfiles..."

backup_and_link () {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target..."
        mv "$target" "$target.backup"
    fi

    echo "Linking $target -> $source"
    ln -sfn "$source" "$target"
}

# Ensure config directory exists
mkdir -p "$CONFIG"

backup_and_link "$DOTFILES/starship" "$CONFIG/starship"
backup_and_link "$DOTFILES/hypr" "$CONFIG/hypr"
backup_and_link "$DOTFILES/wofi" "$CONFIG/wofi"
backup_and_link "$DOTFILES/waybar" "$CONFIG/waybar"
backup_and_link "$DOTFILES/alacritty" "$CONFIG/alacritty"

# Add starship to bashrc if not present
if ! grep -q 'starship init bash' "$BASHRC"; then
    echo "Adding starship config to .bashrc..."

    cat << 'EOF' >> "$BASHRC"

# Starship config
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init bash)"
EOF
fi

echo "Installation complete! :)"
echo "Restart your terminal or run: source ~/.bashrc"


