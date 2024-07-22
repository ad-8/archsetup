#!/usr/bin/bash

print_heading() {
    input_string="$*"
    string_length=${#input_string}
    asterisks_line=$(printf '%*s' "$string_length" | tr ' ' '*')

    echo
    echo "$asterisks_line"
    echo "$input_string"
    echo "$asterisks_line"
}


print_heading "Installing paru packages"
packages=$(grep -v '^$' pkgs/paru | sort | tr '\n' ' ')
paru -S --needed --noconfirm $packages


print_heading "Installing DOOM Emacs"
rm -rf ~/.emacs.d
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

# TODO `emacs --daemon` does NOT start anymore after this (not even if the config files in the doom dir are replaced "manually")
#rm -rf $HOME/.config/doom
#git clone https://github.com/ad-8/doom-emacs-config $HOME/.config/doom
#$HOME/.config/emacs/bin/doom sync


print_heading "dotfiles"
mkdir -p $HOME/.local/share
rm -rf ~/.config/fish
mkdir -p ~/my
cd ~/my
git clone https://github.com/ad-8/dotfiles
cd dotfiles
stow -vR --target=$HOME *


print_heading "scripts"
cd $HOME/my
git clone https://github.com/ad-8/scripts


print_heading "nnn plugins"
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"


print_heading "Fixing light (A program to control backlights and other hardware lights)"
mkdir -p $HOME/.config/light/targets/sysfs/backlight/auto
echo "0" > $HOME/.config/light/targets/sysfs/backlight/auto/minimum
echo "done"


print_heading "changig shell to fish"
chsh -s /usr/bin/fish


print_heading "DONE"
