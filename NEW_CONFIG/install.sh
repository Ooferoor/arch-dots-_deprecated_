#!/usr/bin/env bash
set -euo pipefail

echo "==> Updating system..."
sudo pacman -Syu --noconfirm

# -------------------------
# Package lists
# -------------------------

PACMAN_PACKAGES=(
    base-devel
    git
    bluez
    bluez-utils
    bluez-libs
    blueman
    brightnessctl
    btop
    cava
    curl
    wget
    fastfetch
    gtk3
    gtk4
    gtk-engine-murrine
    gnome-themes-extra
    gvfs
    gvfs-mtp
    gvfs-smb
    hyprland
    hyprshot
    grim
    slurp
    wl-clipboard
    pavucontrol
    pamixer
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    wireplumber
    playerctl
    polkit
    polkit-gnome
    python
    swaync
    networkmanager
    network-manager-applet
    nm-connection-editor
    mesa
    vulkan-radeon
    wayland
    wayland-protocols
    xorg-xwayland
    waybar
    rofi
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    thunar
    thunar-archive-plugin
    thunar-volman
    file-roller
    kitty
    starship
    zsh
    wlogout
    noto-fonts
    noto-fonts-emoji
    ttf-jetbrains-mono-nerd
    papirus-icon-theme
)

AUR_PACKAGES=(
    cliphist
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