#!/usr/bin/env sh

LOG_FILE="$HOME/archsetup-part2.log"
exec > >(tee -a "$LOG_FILE") 2>&1

source ./utils.sh


print_heading "Installing paru packages"
packages=$(grep -v '^$' $SCRIPT_DIR/pkgs/paru | sort | tr '\n' ' ')
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
# TODO stow will fail if a single config dir, e.g. ~/.config/fish, already exists
rm -rf ~/.config/fish
cd $HOME
git clone https://github.com/ad-8/dotfiles
cd dotfiles
stow -vR --target=$HOME *


print_heading "scripts"
cd $HOME
git clone https://github.com/ad-8/scripts


print_heading "nnn plugins"
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"


print_heading "Fixing light (A program to control backlights and other hardware lights)"
mkdir -p $HOME/.config/light/targets/sysfs/backlight/auto
echo "0" > $HOME/.config/light/targets/sysfs/backlight/auto/minimum
echo "done"


print_heading "Restoring crontab"
(crontab -l 2>/dev/null; cat $SCRIPT_DIR/cfgs/crontab.bak) | crontab -
echo "done"


print_heading "getting alacritty themes"
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes


print_heading "changing shell to fish"
chsh -s /usr/bin/fish


print_heading "DONE"
