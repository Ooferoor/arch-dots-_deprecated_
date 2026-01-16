#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system..."
sudo pacman -Syu --noconfirm

# -------------------------
# Package lists
# -------------------------

PACMAN_PACKAGES=(
	# Base System
base-devel git sudo zsh neovim wget fd btop nano
linux linux-firmware amd-ucode	
	)
AUR_PACKAGES=(
	# Wayland / Hyprland stack
hyprland hyprlock
wlroots0.17 wayland wayland-protocols xorg-xwayland
xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal-wlr kitty
	# Bars / Launcher / UI
waybar rofi rofi-emoji swaync wlogout nwg-look waypaper starship
	# Ultities
grim slurp swww swaybg wl-clipboard playerctl brightnessctl satty xcur2png fastfetch cava thunar
	# Audio
pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol
	# Network / Bluetooth
networkmanager network-manager-applet bluez bluez-utils blueman
	# GTK 
gtk2 gtk3 gtk4
	# Fonts
ttf-firacode-nerd ttf-jetbrains-mono-nerd
noto-fonts noto-fonts-emoji noto-fonts-cjk
ttf-dejavu ttf-liberation
)

# -------------------------
# Install pacman packages
# -------------------------

echo "==> Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# -------------------------
# Install yay if missing
# -------------------------

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

# -------------------------
# Install AUR packages
# -------------------------

if [ "${#AUR_PACKAGES[@]}" -gt 0 ]; then
    echo "==> Installing AUR packages..."
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
fi

# -------------------------
# Enable services
# -------------------------

echo "==> Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth

# PipeWire is socket-activated (do NOT enable pipewire.service)
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# -------------------------
# Backup and copy configs
# -------------------------

echo "==> Backing up existing config..."
if [ -d "$HOME/.config" ]; then
    mv "$HOME/.config" "$HOME/.config.backup.$(date +%s)"
fi

echo "==> Copying dotfiles..."
cp -r "$HOME/arch-dotfiles/.config" "$HOME/.config"

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
