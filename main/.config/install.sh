#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
    echo "Do not run this script as root"
    exit 1
fi

if ! grep -qi arch /etc/os-release; then
    echo "This script is intended for Arch Linux only"
    exit 1
fi

read -rp "Run full system upgrade? [y/N] " upgrade_yn
[[ "$yn" =~ ^[Yy]$ ]] && sudo pacman -Syu --noconfirm

read -rp "Do you want to install ufw(firewall)? [y/N] " ufw_yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed ufw --noconfirm
fi

# Package lists

PACMAN_PACKAGES=(
	# Base System
base-devel git sudo zsh neovim wget fd btop
nvim linux linux-firmware amd-ucode pipewire-jack
	)
YAY_PACKAGES=(
	# Wayland / Hyprland stack
hyprland hyprlock
wlroots0.17 wayland wayland-protocols xorg-xwayland
xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal-wlr kitty
	# Bars / Launcher / UI
waybar rofi rofi-emoji swaync wlogout nwg-look waypaper starship
	# Ultities
grim slurp swww wl-clipboard playerctl brightnessctl satty xcur2png fastfetch cava yazi fastfetch fzf spicetify waypaper 
	# Audio
pipewire pipewire-alsa pipewire-pulse wireplumber pavucontrol
	# Network / Bluetooth
networkmanager network-manager-applet bluez bluez-utils blueman
	# GTK 
gtk2 gtk3 gtk4
	# Fonts
ttf-firacode-nerd ttf-jetbrains-mono-nerd
noto-fonts noto-fonts-emoji noto-fonts-cjk
ttf-dejavu ttf-liberation
)

# Install pacman packages

echo "==> Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# Install yay if missing

if ! command -v yay &>/dev/null; then
    echo "==> yay not found, installing..."
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    pushd "$tmpdir/yay"
    makepkg -si --noconfirm
    popd
    rm -rf "$tmpdir"
else
    echo "==> yay already installed"
fi

# Install AUR packages

if [ "${#YAY_PACKAGES[@]}" -gt 0 ]; then
    echo "==> Installing AUR packages..."
    yay -S --needed --noconfirm "${YAY_PACKAGES[@]}" || {
        echo "==> yay failed — check AUR build logs above"
        exit 1
}
fi

# Enable services

echo "==> Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
if command -v ufw &>/dev/null; then
    echo "==> Configuring UFW..."
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo systemctl enable ufw
    sudo systemctl start ufw
    sudo ufw --force enable
fi
if systemctl --user status &>/dev/null; then
    systemctl --user enable --now pipewire pipewire-pulse wireplumber
else
    echo "User systemd not available, skipping user services"
fi

# -------------------------
# Backup and copy configs
# -------------------------

BACKUP="$HOME/.config.backup.$(date +%Y%m%d-%H%M%S)"

if [ -d "$HOME/.config" ]; then
    echo "==> Moving existing ~/.config to $BACKUP"
    mv "$HOME/.config" "$BACKUP"
fi

echo "==> Copying dotfiles..."
cp -r "$HOME/arch-dots/NEW_CONFIG/main" "$HOME/.config"

echo "==> Copying .zshrc"
cp -r "$HOME/arch-dots/.zshrc" "$HOME"

echo "==> Setup complete ✔"

# -------------------------
# Zsh + Oh My Zsh
# -------------------------

echo "==> Setting Zsh as default shell..."
if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s /bin/zsh "$USER"
fi

echo "==> Installing Oh My Zsh..."

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "==> Oh My Zsh already installed"
fi

# for later to keep track, You need to setup the zsh install and edit current configs cause current doesn't work

# Not working currently need to add packages and use yay for most stuff
