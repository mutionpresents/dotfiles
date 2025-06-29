# Mution's Dotfiles

Personal dotfiles and configuration setup for Linux — tested primarily on **Arch Linux** and **Linux Mint**.

---

## 📁 Contents

This repo contains:

- `.bashrc` – Custom shell configuration
- `.config/i3` – i3 window manager setup
- `.config/kitty` – Kitty terminal configuration
- `Pictures/Wallpapers` – Collection of anime wallpapers used in lock screen or desktop
- `Desktop/Ascii-art-for-neofetch` – ASCII art files for terminal fetch tools like Neofetch or Fastfetch

---

## ⚙️ Requirements

These tools should be installed before running the setup (most are available via `pacman` or `apt`):

git
stow
i3
kitty
neofetch
fastfetch


### 📦 Arch Linux:

    bash
    sudo pacman -S --needed git stow i3 kitty neofetch fastfetch

### 📦 Debian/Ubuntu/Linux Mint:

    sudo apt install git stow i3 kitty neofetch fastfetch

### 🚀 Setup Instructions

Clone this repository

    git clone https://github.com/mutionpresents/dotfiles.git ~/dotfiles
    cd ~/dotfiles

    #Run the setup script

    ./setup.sh

This will install the necessary packages (on Arch) and symlink dotfiles using stow.
🔁 Reapplying or Updating

If you update your dotfiles:

    cd ~/dotfiles
    git pull
    ./setup.sh

### 🧠 Notes

Press Mod+Enter to open a terminal (Kitty).

Wallpapers are stored in ~/Pictures/Wallpapers and are used with tools like feh, i3lock, or pywal.

    Make sure your terminal supports 24-bit color and UTF-8 for best results.

    ASCII art works best with fixed-width fonts in terminal sizes that fit the layout.

🛠️ Customization Tip

Feel free to fork or clone this and adjust it for your own setup. Pull requests are welcome if you find improvements!
