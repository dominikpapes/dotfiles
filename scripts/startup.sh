#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root"
   exit 1
fi


REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)


ENABLE_CONFIG=false
if [[ "$1" == "--config" || "$1" == "-c" ]]; then
    ENABLE_CONFIG=true
fi


if [ "$ENABLE_CONFIG" = true ]; then
    echo "Applying DNF and Bash configurations..."

    # DNF config
    if ! grep -q "max_parallel_downloads=10" /etc/dnf/dnf.conf; then
        cat <<EOF >> /etc/dnf/dnf.conf
max_parallel_downloads=10
defaultyes=True
color=always\n
EOF
    fi

    # Bash Config
    echo "set completion-ignore-case on\n" >> "$USER_HOME/.inputrc"
    cat <<EOF >> "$USER_HOME/.bashrc"
# Neovim
alias vi='nvim'
alias vim='nvim'
export EDITOR='nvim'
export VISUAL='nvim'\n
EOF
else
    echo "Skipping configuration (use --config to enable)."
fi


# General Update
dnf upgrade -y --refresh


# RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


# Multimedia Codecs
dnf swap ffmpeg-free ffmpeg --allowerasing
dnf group upgrade -y multimedia --exclude=PackageKit-gstreamer-plugin


# Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Apps
dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda mpv neovim gnome-tweaks papirus-icon-theme autojump
flatpak install -y flathub com.mattjakeman.ExtensionManager
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.mastermindzh.tidal-hifi

