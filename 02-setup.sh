#!/usr/bin/bash

echo -e "\ninstalling paru packages"
echo "********************"
packages=$(grep -v '^$' paru-packages | sort | tr '\n' ' ')
paru -S --needed --noconfirm $packages


echo -e "\ninstalling DOOM emacs"
echo "********************"
rm -rf ~/.emacs.d
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install

# TODO `emacs --daemon` does NOT start anymore after this
#rm -rf $HOME/.config/doom
#git clone https://github.com/ad-8/doom-emacs-config $HOME/.config/doom
#$HOME/.config/emacs/bin/doom sync


echo -e "\ndotfiles"
echo "********************"
mkdir -p $HOME/.local/share
rm -rf ~/.config/fish
mkdir -p ~/my
cd ~/my
git clone https://github.com/ad-8/dotfiles
cd dotfiles
stow -vR --target=$HOME *


echo -e "\nscripts"
echo "********************"
cd $HOME/my
git clone https://github.com/ad-8/scripts


echo -e "\nnnn plugins"
echo "********************"
sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"


echo -e "\nchangig shell to fish"
echo "********************"
chsh -s /usr/bin/fish


echo -e "\n********************"
echo "DONE"
echo "********************"
