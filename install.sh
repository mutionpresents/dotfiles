#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
HOME_DIR="$SCRIPT_DIR/home"
LOCAL_DIR="$SCRIPT_DIR/local"
SDDM_DIR="$SCRIPT_DIR/sddm"
WALLPAPERS_DIR="$SCRIPT_DIR/wallpapers"
PACKAGES_DIR="$SCRIPT_DIR/packages"

# Logging
LOG_FILE="$HOME/dotfiles-install.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

# Banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  Hyprland Dotfiles Installer                ║"
    echo "║              Automated Configuration Setup                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Detect distribution
detect_distro() {
    echo -e "${CYAN}🔍 Detecting system...${NC}"
    
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        DISTRO_NAME=$NAME
        VERSION=$VERSION_ID
        
        # Handle Arch-based distributions
        if [ "$ID_LIKE" = "arch" ] || [ "$ID" = "endeavouros" ] || [ "$ID" = "manjaro" ]; then
            DISTRO="arch"
            echo -e "${BLUE}   Detected Arch-based distribution: $NAME${NC}"
        fi
    else
        echo -e "${RED}❌ Cannot detect distribution${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Detected: $DISTRO_NAME${NC}"
    echo -e "${BLUE}   Version: $VERSION${NC}"
    echo -e "${BLUE}   Base: $DISTRO${NC}"
    
    # Check if Wayland is available
    if [ -n "$WAYLAND_DISPLAY" ] || [ -n "$XDG_SESSION_TYPE" ] && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        echo -e "${GREEN}✅ Wayland session detected${NC}"
    else
        echo -e "${YELLOW}⚠️  No Wayland session detected (this is fine for installation)${NC}"
    fi
}

# Check dependencies
check_dependencies() {
    echo -e "${CYAN}🔍 Checking dependencies...${NC}"
    
    local missing_deps=()
    local deps=("git" "wget" "curl")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}❌ Missing dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Installing basic dependencies...${NC}"
        
        case $DISTRO in
            arch)
                sudo pacman -S --needed "${missing_deps[@]}"
                ;;
            fedora)
                sudo dnf install -y "${missing_deps[@]}"
                ;;
            ubuntu|debian)
                sudo apt update && sudo apt install -y "${missing_deps[@]}"
                ;;
        esac
    fi
}

# Install packages based on distribution
install_packages() {
    echo -e "${YELLOW}📦 Installing packages...${NC}"
    
    case $DISTRO in
        arch)
            echo -e "${BLUE}Installing Arch/Arch-based packages...${NC}"
            
            # Detect specific Arch-based distribution features
            if [ "$ID" = "endeavouros" ]; then
                echo -e "${GREEN}EndeavourOS detected - using optimized package installation${NC}"
                # EndeavourOS comes with yay pre-installed usually
                if ! command -v yay &> /dev/null && ! command -v paru &> /dev/null; then
                    echo -e "${YELLOW}Installing yay AUR helper...${NC}"
                    sudo pacman -S --needed base-devel git
                    git clone https://aur.archlinux.org/yay.git /tmp/yay
                    cd /tmp/yay && makepkg -si --noconfirm
                    cd - > /dev/null
                fi
            elif [ "$ID" = "manjaro" ]; then
                echo -e "${GREEN}Manjaro detected - using pamac/pacman${NC}"
            fi
            
            # Check for AUR helper
            if command -v paru &> /dev/null; then
                echo -e "${GREEN}Using paru for package installation${NC}"
                if [ -f "$PACKAGES_DIR/arch-packages.txt" ]; then
                    paru -S --needed --noconfirm - < "$PACKAGES_DIR/arch-packages.txt"
                fi
                if [ -f "$PACKAGES_DIR/arch-aur-packages.txt" ]; then
                    echo -e "${BLUE}Installing AUR packages...${NC}"
                    paru -S --needed --noconfirm - < "$PACKAGES_DIR/arch-aur-packages.txt"
                fi
            elif command -v yay &> /dev/null; then
                echo -e "${GREEN}Using yay for package installation${NC}"
                if [ -f "$PACKAGES_DIR/arch-packages.txt" ]; then
                    yay -S --needed --noconfirm - < "$PACKAGES_DIR/arch-packages.txt"
                fi
                if [ -f "$PACKAGES_DIR/arch-aur-packages.txt" ]; then
                    echo -e "${BLUE}Installing AUR packages...${NC}"
                    yay -S --needed --noconfirm - < "$PACKAGES_DIR/arch-aur-packages.txt"
                fi
            elif command -v pamac &> /dev/null && [ "$ID" = "manjaro" ]; then
                echo -e "${GREEN}Using pamac for Manjaro package installation${NC}"
                if [ -f "$PACKAGES_DIR/arch-packages.txt" ]; then
                    pamac install --no-confirm - < "$PACKAGES_DIR/arch-packages.txt"
                fi
                if [ -f "$PACKAGES_DIR/arch-aur-packages.txt" ]; then
                    echo -e "${BLUE}Installing AUR packages with pamac...${NC}"
                    pamac build --no-confirm - < "$PACKAGES_DIR/arch-aur-packages.txt"
                fi
            else
                echo -e "${YELLOW}No AUR helper found, using pacman only${NC}"
                if [ -f "$PACKAGES_DIR/arch-packages.txt" ]; then
                    sudo pacman -S --needed --noconfirm - < "$PACKAGES_DIR/arch-packages.txt"
                fi
                if [ -f "$PACKAGES_DIR/arch-aur-packages.txt" ]; then
                    echo -e "${RED}⚠️  AUR packages found but no AUR helper available${NC}"
                    echo -e "${YELLOW}Please install paru or yay and run again for full functionality${NC}"
                fi
            fi
            ;;
        
        fedora)
            echo -e "${BLUE}Installing Fedora packages...${NC}"
            if [ -f "$PACKAGES_DIR/fedora-packages.txt" ]; then
                sudo dnf install -y $(cat "$PACKAGES_DIR/fedora-packages.txt" | tr '\n' ' ')
            fi
            
            # Enable RPM Fusion if needed
            if grep -q "rpmfusion" "$PACKAGES_DIR/fedora-packages.txt" 2>/dev/null; then
                echo -e "${BLUE}Enabling RPM Fusion repositories...${NC}"
                sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
                sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            fi
            ;;
        
        ubuntu|debian)
            echo -e "${BLUE}Installing Ubuntu/Debian packages...${NC}"
            sudo apt update
            if [ -f "$PACKAGES_DIR/ubuntu-packages.txt" ]; then
                sudo apt install -y $(cat "$PACKAGES_DIR/ubuntu-packages.txt" | tr '\n' ' ')
            fi
            
            # Add additional repositories if needed
            if grep -q "hyprland" "$PACKAGES_DIR/ubuntu-packages.txt" 2>/dev/null; then
                echo -e "${BLUE}Adding Hyprland repository...${NC}"
                # Add instructions for Hyprland on Ubuntu if needed
            fi
            ;;
        
        *)
            echo -e "${YELLOW}⚠️  Unsupported distribution: $DISTRO_NAME${NC}"
            echo -e "${BLUE}Detected base: $DISTRO${NC}"
            
            # Try to handle unknown Arch-based distributions
            if [ "$ID_LIKE" = "arch" ] || command -v pacman &> /dev/null; then
                echo -e "${YELLOW}This appears to be an Arch-based distribution. Attempting Arch installation...${NC}"
                read -p "Continue with Arch-based installation? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    DISTRO="arch"
                    # Re-run arch installation
                    if [ -f "$PACKAGES_DIR/arch-packages.txt" ]; then
                        sudo pacman -S --needed --noconfirm - < "$PACKAGES_DIR/arch-packages.txt"
                    fi
                    return
                fi
            fi
            
            echo -e "${YELLOW}Please install packages manually from:${NC}"
            if [ -f "$PACKAGES_DIR/base-packages.txt" ]; then
                echo -e "${BLUE}Base packages needed:${NC}"
                cat "$PACKAGES_DIR/base-packages.txt"
            fi
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
            ;;
    esac
    
    echo -e "${GREEN}✅ Package installation completed${NC}"
}

# Backup existing configurations
backup_configs() {
    echo -e "${YELLOW}💾 Backing up existing configurations...${NC}"
    
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    local configs_to_backup=("hypr" "waybar" "rofi" "wofi" "kitty" "fastfetch" "nvim" "btop" "cava" "conky")
    
    for config in "${configs_to_backup[@]}"; do
        if [ -d "$HOME/.config/$config" ]; then
            echo -e "${BLUE}  Backing up $config...${NC}"
            cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
        fi
    done
    
    # Backup shell configs
    for shell_config in .bashrc .bash_profile .profile .zshrc; do
        if [ -f "$HOME/$shell_config" ]; then
            echo -e "${BLUE}  Backing up $shell_config...${NC}"
            cp "$HOME/$shell_config" "$BACKUP_DIR/"
        fi
    done
    
    if [ "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
        echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"
    else
        echo -e "${YELLOW}ℹ️  No existing configurations found to backup${NC}"
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    fi
}

# Install configuration files
install_configs() {
    echo -e "${YELLOW}⚙️  Installing configurations...${NC}"
    
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    
    # Install .config files
    if [ -d "$CONFIG_DIR" ]; then
        echo -e "${BLUE}Installing .config files...${NC}"
        cp -r "$CONFIG_DIR"/* "$HOME/.config/"
        echo -e "${GREEN}✅ Configuration files installed${NC}"
    fi
    
    # Install home directory files (bashrc, etc.)
    if [ -d "$HOME_DIR" ]; then
        echo -e "${BLUE}Installing home directory files...${NC}"
        for file in "$HOME_DIR"/.*; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                echo -e "${BLUE}  Installing $filename...${NC}"
                cp "$file" "$HOME/$filename"
            fi
        done
        echo -e "${GREEN}✅ Home directory files installed${NC}"
    fi
    
    # Install .local files
    if [ -d "$LOCAL_DIR" ]; then
        echo -e "${BLUE}Installing .local files...${NC}"
        cp -r "$LOCAL_DIR"/* "$HOME/.local/"
        
        # Make scripts executable
        if [ -d "$HOME/.local/bin" ]; then
            find "$HOME/.local/bin" -type f -exec chmod +x {} \;
            echo -e "${GREEN}✅ Scripts made executable${NC}"
        fi
        
        echo -e "${GREEN}✅ Local files installed${NC}"
    fi
    
    # Install wallpapers
    if [ -d "$WALLPAPERS_DIR" ]; then
        echo -e "${BLUE}Installing wallpapers...${NC}"
        mkdir -p "$HOME/Pictures/wallpapers"
        cp "$WALLPAPERS_DIR"/* "$HOME/Pictures/wallpapers/" 2>/dev/null || true
        echo -e "${GREEN}✅ Wallpapers installed${NC}"
    fi
    
    # Set correct permissions
    find "$HOME/.config" -type f -exec chmod 644 {} \; 2>/dev/null || true
    find "$HOME/.config" -type d -exec chmod 755 {} \; 2>/dev/null || true
}

# Install SDDM themes and configuration
install_sddm() {
    if [ -d "$SDDM_DIR" ]; then
        echo -e "${YELLOW}🎨 Installing SDDM themes and configuration...${NC}"
        
        # Check if SDDM is installed
        if ! command -v sddm &> /dev/null; then
            echo -e "${RED}⚠️  SDDM not found. Skipping SDDM installation.${NC}"
            return
        fi
        
        # Install themes
        if [ -d "$SDDM_DIR/themes" ] && [ "$(ls -A $SDDM_DIR/themes 2>/dev/null)" ]; then
            echo -e "${BLUE}Installing SDDM themes...${NC}"
            sudo mkdir -p /usr/share/sddm/themes
            sudo cp -r "$SDDM_DIR/themes"/* /usr/share/sddm/themes/
            echo -e "${GREEN}✅ SDDM themes installed${NC}"
        fi
        
        # Install configuration
        if [ -f "$SDDM_DIR/config/sddm.conf" ]; then
            echo -e "${BLUE}Installing SDDM configuration...${NC}"
            
            # Backup existing config
            if [ -f /etc/sddm.conf ]; then
                sudo cp /etc/sddm.conf "/etc/sddm.conf.backup.$(date +%Y%m%d_%H%M%S)"
            fi
            
            sudo cp "$SDDM_DIR/config/sddm.conf" /etc/sddm.conf
            echo -e "${GREEN}✅ SDDM configuration installed${NC}"
        fi
        
        # Install config directory
        if [ -d "$SDDM_DIR/config/sddm.conf.d" ]; then
            sudo mkdir -p /etc/sddm.conf.d
            sudo cp -r "$SDDM_DIR/config/sddm.conf.d"/* /etc/sddm.conf.d/
        fi
        
        echo -e "${GREEN}✅ SDDM installation completed${NC}"
    fi
}

# Enable and configure services
enable_services() {
    echo -e "${YELLOW}🔧 Configuring services...${NC}"
    
    # Enable SDDM if installed
    if command -v sddm &> /dev/null; then
        echo -e "${BLUE}Enabling SDDM display manager...${NC}"
        sudo systemctl enable sddm
        echo -e "${GREEN}✅ SDDM enabled${NC}"
    elif command -v gdm &> /dev/null; then
        echo -e "${BLUE}GDM found, you may want to switch to SDDM for better Hyprland integration${NC}"
    fi
    
    # Enable audio services
    if command -v pipewire &> /dev/null; then
        echo -e "${BLUE}Enabling PipeWire audio services...${NC}"
        systemctl --user enable pipewire pipewire-pulse
        echo -e "${GREEN}✅ PipeWire services enabled${NC}"
    fi
    
    # Enable Bluetooth if available
    if systemctl list-unit-files | grep -q "bluetooth.service"; then
        echo -e "${BLUE}Enabling Bluetooth service...${NC}"
        sudo systemctl enable bluetooth
        echo -e "${GREEN}✅ Bluetooth enabled${NC}"
    fi
}

# Install additional fonts
install_fonts() {
    echo -e "${YELLOW}🔤 Installing additional fonts...${NC}"
    
    # Create fonts directory
    mkdir -p "$HOME/.local/share/fonts"
    
    # Define required fonts that might not be in package managers
    local required_fonts=(
        "JetBrainsMono Nerd Font"
        "FiraCode Nerd Font" 
        "Hack Nerd Font"
        "Font Awesome"
    )
    
    # Check if fonts directory exists in dotfiles
    if [ -d "$LOCAL_DIR/share/fonts" ]; then
        echo -e "${BLUE}Installing custom fonts from dotfiles...${NC}"
        cp -r "$LOCAL_DIR/share/fonts"/* "$HOME/.local/share/fonts/" 2>/dev/null || true
    fi
    
    # Download popular Nerd Fonts if not present
    for font in "${required_fonts[@]}"; do
        if ! fc-list | grep -qi "${font}"; then
            echo -e "${YELLOW}Font '${font}' not found. Consider installing it manually.${NC}"
        else
            echo -e "${GREEN}✅ Font '${font}' is available${NC}"
        fi
    done
    
    # Offer to download Nerd Fonts
    if ! fc-list | grep -qi "nerd font"; then
        echo -e "${YELLOW}⚠️  No Nerd Fonts detected. These are recommended for terminal and Waybar icons.${NC}"
        read -p "Download JetBrainsMono Nerd Font? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            download_nerd_font "JetBrainsMono"
        fi
    fi
}

# Download Nerd Font
download_nerd_font() {
    local font_name="$1"
    echo -e "${BLUE}Downloading ${font_name} Nerd Font...${NC}"
    
    local font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font_name}.zip"
    local temp_dir=$(mktemp -d)
    
    if command -v wget &> /dev/null; then
        wget -q "$font_url" -O "$temp_dir/${font_name}.zip"
    elif command -v curl &> /dev/null; then
        curl -sL "$font_url" -o "$temp_dir/${font_name}.zip"
    else
        echo -e "${RED}❌ Neither wget nor curl found. Cannot download fonts.${NC}"
        return 1
    fi
    
    if [ -f "$temp_dir/${font_name}.zip" ]; then
        echo -e "${BLUE}Extracting ${font_name}...${NC}"
        unzip -q "$temp_dir/${font_name}.zip" -d "$HOME/.local/share/fonts/"
        rm -rf "$temp_dir"
        echo -e "${GREEN}✅ ${font_name} Nerd Font installed${NC}"
    else
        echo -e "${RED}❌ Failed to download ${font_name}${NC}"
    fi
}

# Post-installation setup
post_install_setup() {
    echo -e "${YELLOW}🔧 Running post-installation setup...${NC}"
    
    # Install fonts
    install_fonts
    
    # Update font cache
    if command -v fc-cache &> /dev/null; then
        echo -e "${BLUE}Updating font cache...${NC}"
        fc-cache -fv
        echo -e "${GREEN}✅ Font cache updated${NC}"
    fi
    
# Validate font installation
validate_fonts() {
    echo -e "${CYAN}🔍 Validating font installation...${NC}"
    
    local critical_fonts=(
        "Font Awesome"
        "Noto"
    )
    
    local recommended_fonts=(
        "JetBrains Mono"
        "Fira Code"
        "Hack"
    )
    
    local missing_critical=()
    local missing_recommended=()
    
    # Check critical fonts
    for font in "${critical_fonts[@]}"; do
        if ! fc-list | grep -qi "$font"; then
            missing_critical+=("$font")
        fi
    done
    
    # Check recommended fonts  
    for font in "${recommended_fonts[@]}"; do
        if ! fc-list | grep -qi "$font"; then
            missing_recommended+=("$font")
        fi
    done
    
    # Report results
    if [ ${#missing_critical[@]} -ne 0 ]; then
        echo -e "${RED}❌ Missing critical fonts: ${missing_critical[*]}${NC}"
        echo -e "${YELLOW}These fonts are required for proper display. Install them manually if needed.${NC}"
    fi
    
    if [ ${#missing_recommended[@]} -ne 0 ]; then
        echo -e "${YELLOW}⚠️  Missing recommended fonts: ${missing_recommended[*]}${NC}"
        echo -e "${BLUE}These fonts will improve the visual experience but aren't critical.${NC}"
    fi
    
    if [ ${#missing_critical[@]} -eq 0 ] && [ ${#missing_recommended[@]} -eq 0 ]; then
        echo -e "${GREEN}✅ All recommended fonts are installed${NC}"
    fi
}
    
    # Update XDG database
    if command -v update-desktop-database &> /dev/null; then
        echo -e "${BLUE}Updating desktop database...${NC}"
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi
    
    # Update MIME database
    if command -v update-mime-database &> /dev/null; then
        echo -e "${BLUE}Updating MIME database...${NC}"
        update-mime-database "$HOME/.local/share/mime" 2>/dev/null || true
    fi
    
    # Validate fonts
    validate_fonts
    
    # Source shell configuration
    echo -e "${BLUE}Reloading shell configuration...${NC}"
    if [ -f "$HOME/.bashrc" ]; then
        echo -e "${YELLOW}ℹ️  Please run 'source ~/.bashrc' or restart your shell${NC}"
    fi
}
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Installation Complete!                   ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}🎉 Your Hyprland dotfiles have been installed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "${BLUE}1.${NC} Log out of your current session"
    echo -e "${BLUE}2.${NC} Select 'Hyprland' from your display manager"
    echo -e "${BLUE}3.${NC} Log in and enjoy your new setup!"
    echo ""
    echo -e "${YELLOW}Useful commands:${NC}"
    echo -e "${BLUE}• Super + Q${NC} - Close window"
    echo -e "${BLUE}• Super + Return${NC} - Open terminal"
    echo -e "${BLUE}• Super + D${NC} - Application launcher"
    echo -e "${BLUE}• Super + M${NC} - Exit Hyprland"
    echo ""
    echo -e "${YELLOW}Configuration files:${NC}"
    echo -e "${BLUE}• Hyprland:${NC} ~/.config/hypr/hyprland.conf"
    echo -e "${BLUE}• Waybar:${NC} ~/.config/waybar/"
    echo -e "${BLUE}• Terminal:${NC} ~/.config/kitty/"
    echo ""
    echo -e "${CYAN}Installation log saved to: $LOG_FILE${NC}"
    
    if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
        echo -e "${CYAN}Your original configs were backed up to: $BACKUP_DIR${NC}"
    fi
}

# Main installation function
main() {
    show_banner
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}❌ Don't run this script as root!${NC}"
        exit 1
    fi
    
    # Detect system
    detect_distro
    check_dependencies
    
    # Show installation options
    echo -e "${CYAN}Installation Options:${NC}"
    echo "1) Full installation (packages + configs + SDDM)"
    echo "2) Configs only (skip packages)"
    echo "3) Packages only (skip configs)"
    echo "4) Custom installation (choose components)"
    echo ""
    read -p "Choose installation type (1-4): " choice
    
    case $choice in
        1)
            echo -e "${CYAN}🚀 Starting full installation...${NC}"
            install_packages
            backup_configs
            install_configs
            install_sddm
            enable_services
            post_install_setup
            ;;
        2)
            echo -e "${CYAN}⚙️  Installing configurations only...${NC}"
            backup_configs
            install_configs
            post_install_setup
            ;;
        3)
            echo -e "${CYAN}📦 Installing packages only...${NC}"
            install_packages
            enable_services
            ;;
        4)
            echo -e "${CYAN}🎛️  Custom installation...${NC}"
            echo "Select components to install:"
            
            read -p "Install packages? (y/N): " -n 1 -r pkg_choice
            echo
            read -p "Install configs? (y/N): " -n 1 -r cfg_choice
            echo
            read -p "Install SDDM themes? (y/N): " -n 1 -r sddm_choice
            echo
            
            [[ $pkg_choice =~ ^[Yy]$ ]] && install_packages
            if [[ $cfg_choice =~ ^[Yy]$ ]]; then
                backup_configs
                install_configs
                post_install_setup
            fi
            [[ $sddm_choice =~ ^[Yy]$ ]] && install_sddm
            [[ $pkg_choice =~ ^[Yy]$ ]] && enable_services
            ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    show_completion
}

# Trap to handle interruption
trap 'echo -e "\n${RED}Installation interrupted by user${NC}"; exit 130' INT

# Run main function
main "$@"
