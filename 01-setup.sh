#!/usr/bin/bash

echo -e "\nrunning pacman -Syu"
echo "********************"
pacman -Syu --noconfirm


echo -e "\ninstalling MY packages"
echo "********************"
packages=$(grep -v '^$' pacman-packages | sort | tr '\n' ' ')
pacman -S --needed --noconfirm $packages


echo -e "\ninstalling dependencies for dwm"
echo "********************"
pacman -S --needed --noconfirm gcc make base-devel libx11 libxft libxinerama


echo -e "\ninstalling dwm"
echo "********************"
cd /tmp
git clone https://github.com/ad-8/dwm-ax
cd dwm-ax
# TODO evaluate if this finally works now
mkdir -p /usr/share/xsessions
cp dwm.desktop /usr/share/xsessions/
# chmod was needed on debian
chmod 644 /usr/share/xsessions/dwm.desktop
make
make clean install


# dwmblocks
cd /tmp
git clone https://github.com/ad-8/dwmblocks
cd dwmblocks
make
make clean install


echo -e "\nFlatpak stuff"
echo "********************"
pacman -S --needed --noconfirm flatpak
flatpak install --assumeyes flathub io.gitlab.librewolf-community
flatpak install --assumeyes flathub ch.protonmail.protonmail-bridge


echo -e "\nInstalling Rust"
echo "********************"
pacman -S --needed --noconfirm rustup
sudo -u ax rustup default stable


echo -e "\nParu (AUR helper)"
echo "********************"
pacman -S --needed --noconfirm base-devel
cd /tmp
git clone https://aur.archlinux.org/paru.git
chmod a+w paru
cd paru
sudo -u ax makepkg -si --needed --noconfirm


echo -e "\nDeny SSH root login"
echo "********************"
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/20-deny_root.conf
echo "done"


echo -e "\nDOOM Emacs dependencies"
echo "********************"
# required dependencies
pacman -S --needed --noconfirm git emacs ripgrep
# optional dependencies
pacman -S --needed --noconfirm fd


echo -e "\nInstalling MEGAsync"
echo "********************"
pacman -S --needed --noconfirm wget
cd /tmp
wget https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst
pacman -U --noconfirm "$PWD/megasync-x86_64.pkg.tar.zst"
pacman -Syu --noconfirm


echo -e "\nsystemd timeouts"
echo "********************"
sed -i 's/#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=30s/' /etc/systemd/system.conf
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=30s/' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=30s/' /etc/systemd/system.conf
echo "done"


echo "\n********************"
echo -e "DONE"
echo "********************"
