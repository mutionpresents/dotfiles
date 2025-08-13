# Hyprland Dotfiles

A complete Hyprland configuration setup with automated installation for multiple Linux distributions.

## Screenshots

<!-- Add your screenshots here -->

## Quick Install

```bash
git clone https://github.com/yourusername/hyprland-dotfiles.git
cd hyprland-dotfiles
chmod +x install.sh
./install.sh
```

## What's Included

### Desktop Environment
- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Highly customizable status bar
- **SDDM** - Display manager with custom themes
- **Rofi/Wofi** - Application launcher

### Applications & Tools
- **Kitty** - GPU-accelerated terminal emulator
- **Neovim** - Modern text editor configuration
- **Fastfetch** - System information tool
- **Btop** - Resource monitor
- **Cava** - Audio visualizer
- **Conky** - System monitor widgets

### Features
- **Auto-wallpaper changing** with Hyprpaper
- **Screen locking** with Hyprlock
- **Idle management** with Hypridle
- **Notification system** with Dunst
- **GTK theming** for consistent look
- **Custom scripts** and utilities

## Requirements

### Minimum System Requirements
- **Linux distribution**: Arch, Fedora, or Ubuntu/Debian
- **GPU**: Any GPU with Vulkan support (Intel, AMD, or NVIDIA)
- **RAM**: 4GB minimum, 8GB recommended
- **Display**: Any resolution (optimized for 1920x1080+)

### Dependencies
The installation script will handle most dependencies, but you need:
- `git` - For cloning the repository
- `curl`/`wget` - For downloading packages
- `sudo` privileges - For system-wide installation

## Installation

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/hyprland-dotfiles.git
cd hyprland-dotfiles
```

### 2. Run Installation Script
```bash
chmod +x install.sh
./install.sh
```

### 3. Choose Installation Type
- **Full Installation** - Complete setup with packages and configs
- **Configs Only** - Just dotfiles (if you have packages already)
- **Packages Only** - Just software installation
- **Custom** - Pick specific components

### 4. Post-Installation
1. Log out of your current session
2. Select "Hyprland" from your display manager
3. Log in and enjoy!

## Keybindings

| Key Combination | Action |
|---|---|
| `Super + Q` | Close window |
| `Super + Return` | Open terminal |
| `Super + D` | Application launcher |
| `Super + V` | Toggle floating mode |
| `Super + F` | Toggle fullscreen |
| `Super + M` | Exit Hyprland |
| `Super + L` | Lock screen |
| `Super + 1-9` | Switch to workspace |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Mouse` | Move/resize windows |
| `Super + Alt + Arrow` | Switch focus |
| `Super + Shift + Arrow` | Move window |

## Customization

### Changing Wallpapers
```bash
# Add wallpapers to
~/Pictures/wallpapers/

# Edit Hyprpaper config
nano ~/.config/hypr/hyprpaper.conf
```

### Waybar Configuration
```bash
# Edit Waybar config
nano ~/.config/waybar/config.jsonc
nano ~/.config/waybar/style.css
```

### Color Schemes
This setup uses dynamic color schemes. To change themes:
```bash
# Using wallust (if installed)
wallust run ~/Pictures/wallpapers/your-wallpaper.jpg

# Or edit manually
nano ~/.config/hypr/colors.conf
```

## Repository Structure

```
hyprland-dotfiles/
├── install.sh              # Main installation script
├── README.md               # This file
├── config/                 # Configuration files (~/.config)
│   ├── hypr/              # Hyprland configuration
│   ├── waybar/            # Status bar config
│   ├── kitty/             # Terminal config
│   ├── rofi/              # App launcher config
│   ├── nvim/              # Neovim configuration
│   └── ...                # Other app configs
├── home/                   # Home directory files
│   ├── .bashrc            # Shell configuration
│   └── .profile           # Environment variables
├── local/                  # ~/.local files
│   ├── bin/               # Custom scripts
│   └── share/             # Fonts, themes, icons
├── sddm/                   # SDDM themes and config
│   ├── themes/            # Custom SDDM themes
│   └── config/            # SDDM configuration
├── wallpapers/             # Wallpaper collection
└── packages/               # Package lists per distro
    ├── arch-packages.txt
    ├── fedora-packages.txt
    └── ubuntu-packages.txt
```

## Troubleshooting

### Common Issues

**Hyprland won't start**
```bash
# Check if Hyprland is installed
hyprland --version

# Check logs
journalctl --user -u hyprland

# Verify configuration
hyprland -c ~/.config/hypr/hyprland.conf --dry-run
```

**Waybar not showing**
```bash
# Kill and restart Waybar
pkill waybar
waybar &
```

**Audio not working**
```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse
```

**SDDM theme not applying**
```bash
# Check SDDM configuration
sudo nano /etc/sddm.conf

# Test theme
sudo sddm-greeter --test-mode --theme /usr/share/sddm/themes/your-theme
```

### Getting Help
1. Check the [Issues](https://github.com/yourusername/hyprland-dotfiles/issues) page
2. Review installation logs: `~/dotfiles-install.log`
3. Verify your system meets the requirements
4. Try a clean installation with backup restoration

## Supported Distributions

### Fully Supported
- **Arch Linux** (+ AUR helpers: paru, yay)
- **Fedora** (latest versions)
- **Ubuntu 22.04+**
- **Debian 12+**

### Partial Support
Other distributions may work but require manual package installation.

## Contributing

Contributions are welcome! Here's how to help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Adding Support for New Distros
1. Create package list in `packages/distro-packages.txt`
2. Update `install.sh` with distro detection
3. Test thoroughly and document any special requirements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Hyprland** community for the amazing compositor
- **Waybar** developers for the flexible status bar
- **Arch Linux** community for excellent documentation
- All the amazing theme creators and contributors

## Support

If you found this helpful, please:
- ⭐ Star the repository
- 🐛 Report issues
- 💡 Suggest improvements
- 📢 Share with others

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/yourusername">YourName</a></sub>
</div>