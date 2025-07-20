#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if uwsm check may-start; then
	exec uwsm start hyprland.desktop
fi

export PATH=/home/mution/.local/bin:~/.npn-global/bin:$PATH
export TERM=kitty
export QT_QPA_PLATFORMTHEME=gtk3
