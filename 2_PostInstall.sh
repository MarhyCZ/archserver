#!/bin/bash
printf "\n"
echo "Part 4 - Post Installation"
echo "######################################################"
printf "\n"


useradd -m -G wheel,users -s /bin/bash user

pacman -S sudo openssh wget git
# asi neni potreba sudo echo 'ListenAddress 0.0.0.0' >> /etc/ssh/sshd_config
sudo systemctl start sshd
sudo systemctl enable sshd
echo '[archlinuxfr]' >> /etc/pacman.conf
echo 'SigLevel = Never' >> /etc/pacman.conf
echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
sudo pacman -Sy yaourt