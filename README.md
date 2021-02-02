# get-my-arch
Step-by-step to get my archlinux configuration

## Get Arch
_to be done_

## Install Arch
1. Insert arch boot disk
2. Set the partitions of the disk:
  - `fdisk /dev/sda`
    - d (remove all partitions)
    - n (create a new partition)
    - p (select primary partition)
    - 1 (select partition as 1)
    - Enter, Enter (double enter to select automatic partition size and sector)
    - Yes (remove signature)
    - W (write partition table)
3. Create a system file: `mkfs.ext4 /dev/sda1``
4. Select an arch mirror:
```bash
pacman –Syy
pacman –S reflector (para instalar o reflector)
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
reflector -c "BR" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
```
5. Install arch:
```bash
mount /dev/sda1 /mnt 
pacstrap /mnt base linux linux-firmware vim nano wget
```
6. Configure arch after installation:
```bash
# Create a fstab file
genfstab -U /mnt >> /mnt/etc/fstab
```
```bash
# Access the disk
arch-chroot /mnt
```
```bash
# Set timezone
timedatectl set-timezone America/Sao_Paulo
nano /etc/locale.gen
# Uncomment line of timestamp, for instance: pt_BR.UTF-8
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8
```
```bash
# Configure host and password
echo [hostname] > /etc/hostname
touch /etc/hosts
nano /etc/hosts

# type:
127.0.0.1    localhost 
::1          localhost 
127.0.1.1    [hostname]

# generate a new password
passwd
```
```bash
# Install grub
pacman -S grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```
```bash
# Create a sudo user
useradd -m [user]
passwd [user]
pacman -S sudo
EDITOR=nano visudo

# Add the following line after root
[user] ALL=(ALL) ALL

# Installing KDE Plasma desktop
pacman -S xorg plasma plasma-wayland-session kde-applications
systemctl enable sddm.service
systemctl enable NetworkManager.service
```
```bash
# Configure internet connection
pacman –S wget 
pacman –S b43-fwcutter 
export FIRMWARE_INSTALL_DIR="/lib/firmware" 
wget https://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2 
tar xjf broadcom-wl-5.100.138.tar.bz2 
b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" broadcom-wl-5.100.138/linux/wl_apsta.o 
pacman –S wireless_tools wpa_supplicant wifi-menu dialog 
wifi-menu 
ping google.com 
```
```bash
# Last steps
exit
shutdown now
```
7. Remove USB stick

## Customize your Arch
_to be done_

Reference: https://www.tecmint.com/i3-tiling-window-manager/amp/
Reference: https://onedrive.live.com/redir?resid=C2A4D66CC7C39237%21401315&page=Edit&wd=target%28DEVOPS.one%7Cd8285422-ec2d-4ab3-881c-3a783cf0fdb1%2FINSTALL%20AND%20SETUP%20ARCH%20LINUX%20DEVELOPMENT%20ENV%7C5e289956-c1a6-4ca4-ad85-6ea27fdcc758%2F%29