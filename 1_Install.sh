#!/bin/bash

echo "######################################################"
echo "Vítej v Marhyho instalátoru ArchServeru - UEFI Edition"
echo "######################################################"
printf "\n\n"

echo "Testuji Internet"
ping  -c 3 www.google.com

echo "######################################################"
echo "Part 1 - Disks"
echo "######################################################"
printf "\n"

fdisk -l | grep 'Disk'

echo "Input your drive name (/dev/\$DRIVE). I will format it!"
read DRIVE

printf "\n"
echo "Part 1 - Partitioning disks"
echo "######################################################"
printf "\n"

parted /dev/$DRIVE mklabel gpt
parted /dev/$DRIVE mkpart ESP fat32 0% 513MiB
parted /dev/$DRIVE set 1 boot on
parted /dev/$DRIVE mkpart primary ext4 513MiB 100%

printf "\n"
echo "Part 1 - Creating filesystems"
echo "######################################################"
printf "\n"

mkfs.fat -F32 /dev/${DRIVE}1
mkfs.ext4 /dev/${DRIVE}2

printf "\n"
echo "Part 1 - Mounting partitions"
echo "######################################################"
printf "\n"

mount /dev/${DRIVE}2 /mnt
mkdir -p /mnt/boot
mount /dev/${DRIVE}1 /mnt/boot

printf "\n"
echo "######################################################"
echo "Part 2 - Installing and basic system configuration"
echo "######################################################"
printf "\n\n"


echo "Just for fun: 5 Best mirrors"
cat /etc/pacman.d/mirrorlist | grep -e '^Server' | head -5
printf "\n"

printf "\n"
echo "Part 2 - Installing base system"
echo "######################################################"
printf "\n"

read -r -p "Do you want to also install base-devel package (useful if you build packages)? [Y/n]" response
 response=${response,,}
 if [[ $response =~ ^(yes|y| ) ]]; then
    pacstrap -i /mnt base base-devel
 else
 	pacstrap -i /mnt base
 fi

printf "\n"
echo "Part 2 - Generating fstab"
echo "######################################################"
printf "\n"
 genfstab -U /mnt > /mnt/etc/fstabs

echo "Just for fun: 5 Best mirrors"
cat /mnt/etc/fstabs
printf "\n"

cp 1_InstallPart2.sh /mnt/root/
arch-chroot /mnt /root/1_InstallPart2.sh
