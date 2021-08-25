# get-my-arch

Step-by-step to get my archlinux configuration

## Get Arch

1. Download Arch Linux .iso at <http://archlinux.org/download/>
2. Create a live usb and boot:

```bash
dd bs=4M if=/home/Downloads/archlinux-2020.11.01-x86_64 of=/dev/sdb status=progress && sync
```

## Install Arch

1. Insert arch boot disk
2. Setup the keyboard layout:

```bash
# list all available keyboard layout
ls /usr/share/kbd/keymaps/**/*.map.gz

# load the keyboard layout
loadkeys br-abnt2.map.gz
```

3. Set the partitions of the disk:

- list all partitions: `fdisk -l`
- start cfdisk tool: `cfdisk /dev/sda`
- create three partition (one for arch linux, boot and another for swap area):

  - Delete all partitions
  - Add new partition for arch and define the partition size
  - Add another partition for swap and define the partition size (it should be twice the RAM size)
  - Define its type as Linux swap
  - Add another partition for bios boot and define the partition size
  - Define its type as BIOS Boot
  - Choose `write` option to write the partition table

4. Create a system file: `mkfs.ext4 /dev/sda1`
5. Create a swap file system: `mkswap /dev/sda2`
6. Mount the root file system: `mount /dev/sda1 /mnt`
7. Turn on the swap: `swapon /dev/sda2`
8. Install the base system: `pacstrap /mnt base linux linux-firmware vim nano wget`
9. Create the filesystem table: `genfstab -U /mnt >> /mnt/etc/fstab`
10. Login as root to newly installed Arch: `arch-chroot /mnt`
11. Configure timezone: `ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime`
12. Generate Locale File:

```bash
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
```

13. Install DHCP: `pacman -S dhcpcd`
14. Create a hostname: `echo [hostname] > /etc/hostname`
15. Create a hostname file:

```bash
nano /etc/hosts

# type:
127.0.0.1    localhost
::1          localhost
127.0.0.1    [hostname]
```

16. Enable DHCP: `systemctl enable dhcpcd`
17. Generate root password: `passwd`
18. Create GRUB boot loader:

```bash
pacman -S grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

19. Restart without boot disk:

```bash
# Last steps
exit
shutdown now
```

## Install KDE

1. Create a sudo user:

```bash
# Create a sudo user
useradd -m [user]
passwd [user]
pacman -S sudo
EDITOR=nano visudo

# Add the following line after root
[user] ALL=(ALL) ALL
```

2. Install the packages:

```bash
# Installing KDE Plasma desktop
pacman -S --needed xorg sddm
pacman -S --needed plasma kde-applications
```

3. Enable display server and network:

```bash
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager.service
```

6. The Linux kernel includes open-source video drivers and support for hardware accelerated framebuffers. However, userland support is required for OpenGL and 2D acceleration in X11:

- First, identify the graphics card (the Subsystem output shows the specific model):

```bash
lspci -v | grep -A1 -e VGA -e 3D
```

- Install an appropriate driver. You can search the package database for a complete list of open-source video drivers: <https://wiki.archlinux.org/index.php/xorg#Driver_installation>

```bash
# Search at pacman
pacman -Ss xf86-video

# Install the correct one
pacman -S xf86-video-intel
```

7. Configure sddm and reboot:

```bash
# To change manual configuration at theme
sudo nano /usr/lib/sddm/sddm.conf.d/default.conf

# In theme add
Current=breeze

# Last steps
sudo systemctl reboot
```

8. Install wifi drivers:

```bash
# Configure internet connection
pacman –S b43-fwcutter
export FIRMWARE_INSTALL_DIR="/lib/firmware"
wget https://www.lwfinger.com/b43-firmware/broadcom-wl-5.100.138.tar.bz2
tar xjf broadcom-wl-5.100.138.tar.bz2
sudo b43-fwcutter -w "$FIRMWARE_INSTALL_DIR" broadcom-wl-5.100.138/linux/wl_apsta.o
pacman –S wireless_tools wpa_supplicant dialog
```

## Customize your Arch with KDE

- In System settings:
  - Show menu > Configure > Show in icons
  - Plasma Style > Install Layan and select it
  - App Styles > Window decoration > Download Arc-OSX-aurorae > Select dark version
    - Click Edit at Arc Dark > Button Size: Tiny
  - In tab Titlebar Buttons > remove the two buttons of the left side
    - Drag and drop close, minimize and maximize buttons to the left side
  - Icons > Download Ghost Flat and select
  - Screen Behavior > Screen Locking > Appearance > Select Fluxo
- In Panel:
  - Right Click > Add Widget...
    - Add Global Menu
  - Right button click > Edit panel...
    - Drag Screen edge and drop upper limit of the screen
    - Panel height: 22
    - Remove desktop button
    - Add spacer between global menu and notification widget
  - Right click at notification > Settings > Entries:
    - Vault: Always hidden
    - Clipper: Always hidden
    - Battery: Always shown
    - Volume Control: Always hidden
    - Volume Audio: Always shown
  - Right Click at launcher > Show Alternatives > Application Menu
- Open Dolphin:
  - Hide Recent and Search For sessions
  - Right Click at Toolbar:
    - Text Position: Icons Only
- sudo pacman -S latte-dock
  - Open Latte Dock:
    - Right click > Add Widgets:
      - Add Trash Can > ok
    - Right click > Dock Settings:
      - Remove Clock
      - Visibility > Dodge All Windows
      - Appearance > Active Advanced

_Tutorial for i3: <https://www.tecmint.com/i3-tiling-window-manager/amp/>_

_Set my vim for typescript development: https://thoughtbot.com/blog/modern-typescript-and-react-development-in-vim_
