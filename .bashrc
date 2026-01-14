#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Load pywal colors if available
#if [ -f "$HOME/.cache/wal/colors.sh" ]; then
#    source "$HOME/.cache/wal/colors.sh"
#fi

# fastfetch image:
# CSM:
#fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Makimapfp15.png
#fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Himenopfp3.png
#fastfetch --kitty-direct /home/mution/Pictures/Ascii--art-for-neofetch/Himenopfp4.png
#fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Makimapfp1.png


# Bleach:
fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Rukiapfp9.png
#fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Nellpfp1.png
#fastfetch --kitty-direct ~/Pictures/Ascii-art-for-neofetch/Ichigopfp2.png
# Akame: 
#fastfetch --kitty-direct /home/mution/Pictures/Ascii-art-for-neofetch/Akamepfp2.png

# Tokyo Ghoul:
#fastfetch --kitty-direct ~/Pictures/Ascii-art-for-neofetch/Kanekipfp2.png

# AOT
#fastfetch --kitty-direct ~/Pictures/Ascii-art-for-neofetch/Mikasapfp1.png
#fastfetch --kitty-direct ~/Pictures/Ascii-art-for-neofetch/Mikasapfp2.png

#fastfetch --kitty-direct logoset
#logoset

# Wayland or X11
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export QT_QPA_PLATFORM=wayland
  export QT_QPA_PLATFORMTHEME=qt6ct
  export GDK_BACKEND=wayland
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=Hyprland
  export XDG_CURRENT_DESKTOP=Hyprland
fi

# Font rendering
export FREETYPE_PROPERTIES="truetype:interpreter-version=40"
export QT_FONT_DPI=96
export PATH="$HOME/.local/bin:$PATH"
