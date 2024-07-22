#!/usr/bin/env sh

source ./utils.sh


print_heading "pacman -Syu"
pacman -Syu --noconfirm


print_heading "Installing pacman packages"
packages=$(grep -v '^$' $SCRIPT_DIR/pkgs/pacman | sort | tr '\n' ' ')
pacman -S --needed --noconfirm $packages


print_heading "Installing dependencies for dwm"
pacman -S --needed --noconfirm gcc make base-devel libx11 libxft libxinerama


print_heading "Installing dwm"
cd /tmp
git clone https://github.com/ad-8/dwm-ax
cd dwm-ax
mkdir -p /usr/share/xsessions
cp dwm.desktop /usr/share/xsessions/
chmod 644 /usr/share/xsessions/dwm.desktop
make
make clean install


print_heading "Installing dwmblocks"
cd /tmp
git clone https://github.com/ad-8/dwmblocks
cd dwmblocks
make
make clean install


print_heading "Installing Flatpaks"
packages=$(grep -v '^$' $SCRIPT_DIR/pkgs/flatpak | sort | tr '\n' ' ')
pacman -S --needed --noconfirm flatpak
flatpak install --assumeyes flathub $packages


print_heading "Installing Rust"
pacman -S --needed --noconfirm rustup
sudo -u ax rustup default stable


print_heading "Installing Paru (AUR helper)"
pacman -S --needed --noconfirm base-devel
cd /tmp
git clone https://aur.archlinux.org/paru.git
chmod a+w paru
cd paru
sudo -u ax makepkg -si --needed --noconfirm


print_heading "Deny SSH root login"
echo 'PermitRootLogin no' > /etc/ssh/sshd_config.d/20-deny_root.conf
echo "done"


print_heading "Installing DOOM Emacs dependencies"
# required dependencies
pacman -S --needed --noconfirm git emacs ripgrep
# optional dependencies
pacman -S --needed --noconfirm fd


print_heading "Installing MEGAsync"
pacman -S --needed --noconfirm wget
cd /tmp
wget https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst
pacman -U --noconfirm "$PWD/megasync-x86_64.pkg.tar.zst"
pacman -Syu --noconfirm


print_heading "systemd timeouts"
sed -i 's/#DefaultTimeoutStartSec=90s/DefaultTimeoutStartSec=30s/' /etc/systemd/system.conf
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=30s/' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=30s/' /etc/systemd/system.conf
echo "done"


print_heading "Installing nnn"
pacman -R --noconfirm nnn
cd /tmp
git clone https://github.com/jarun/nnn
cd nnn
make O_NERD=1
make install


print_heading "Installing tabbed for nnn tabbed preview plugin"
cd /tmp
git clone https://git.suckless.org/tabbed
cd tabbed
make
make install


print_heading "Setting up lightdm"
pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter
systemctl enable lightdm


print_heading "Configuring lightdm-gtk-greeter"
cd $SCRIPT_DIR
mkdir -p /etc/lightdm
cp cfgs/lightdm-gtk-greeter.conf /etc/lightdm/
chmod 644 /etc/lightdm/lightdm-gtk-greeter.conf
echo "done"


print_heading "Misc"
gpasswd -a $USERNAME video # requirement for light
echo "done"


print_heading "Setting up cron"
pacman -S --needed --noconfirm cronie
systemctl enable cronie.service


print_heading "DONE"
