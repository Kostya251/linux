#!/bin/bash
# root password

parted /dev/sda --script 'mklabel gpt mkpart "EFI system partition" fat32 1MiB 261MiB set 1 esp on mkpart "root partition" ext4 261MiB 100%'
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot
pacstrap /mnt --needed base linux linux-firmware
genfstab -Up /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<"EOT"
root_passwd=1
username=kk
username_password=1
hostname=astra
echo "root:$root_passwd" | chpasswd
echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
pacman -S --noconfirm bash-completion openssh networkmanager sudo git wget htop neofetch vim
mkinitcpio -p linux
useradd -m -g users -G wheel -s /bin/bash $username
echo "$username:$username_password" | chpasswd
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
pacman -S --noconfirm intel-ucode
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
echo $$
EOT

# Server = https://mirror.yandex.ru/archlinux/$repo/os/$arch

