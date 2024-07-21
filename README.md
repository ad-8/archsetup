# archsetup
My personal setup script. Work in progress.

## System Requirements
To build `paru`, the system should have 6+ GB of RAM (failed in a VM with 4 GB).

## How To
Before running the scripts, check/update the pacman/paru package lists (see `arch.org` document).

1. install arch
2. install `git`, clone this repo && cd into it
3. `sudo ./01-setup.sh`
4. `./02-setup.sh`

## Xorg
If the archinstall script was used w/ the minimal option, that is w/o a desktop environment:
1. install `lightdm` and `lightdm-gtk-greeter`
2. `systemctl enable lightdm`

