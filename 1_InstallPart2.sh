#!/bin/bash
printf "\n"
echo "Part 2 - Time and Language"
echo "######################################################"
printf "\n"

echo "Uncomment your language line (Marhy's tip: LANG=en_US.UTF-8) 5s countdown"
sleep 5
nano /etc/locale.gen
locale-gen
V_LANG=$(cat /etc/locale.gen | grep -v '^#' | cut -d' ' -f1)
echo LANG=$V_LANG > /etc/locale.conf
export LANG=$V_LANG

V_TIMEZONE=$(tzselect)
ln -s /usr/share/zoneinfo/$V_TIMEZONE > /etc/localtime
hwclock --systohc --utc

printf "\n"
echo "######################################################"
echo "Part 3 - Finishing up - Bootloader and hostname"
echo "######################################################"
printf "\n\n"
Pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o boot/grub/grub.cfg

echo "Input your hostname: (Without spaces)"
read V_HOSTNAME
echo "$V_HOSTNAME" > /etc/hostname
passwd
echo "Done. Just issue a 'umount -R /mnt' command and reboot a system."
exit
