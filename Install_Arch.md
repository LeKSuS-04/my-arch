# Install Arch
My Arch Linux installation cheat sheet  
Please note, that I've created this guide for myself using my system's specifications and my own preferences. Process for you might (and most probably would) be slightly different. 

## 1. Arch Linux itself
### 1.1 Connect to wi-fi
Launch internet wireless control utility:
```
iwctl
```
List avaliable wirelss interfaces:
```
station list
```
Scan area for networks and list them:
```
station wlan0 scan
station wlan0 get-networks
```
Connect to network:
```
station wlan0 connect <network>
```
Check your connecion:
```
ping -c 3 archlinux.org
```

### 1.2 Disk partitioning
List disks:
```
fdisk -l
```
Launch gdisk utility:
```
gdisk /dev/sda
```
Remove every existing partition, if any are present:
```
Command (? for help): d
Partition number (1-3): 3

Command (? for help): d
Partition number (1-2): 2

Command (? for help): d
Using 1
```
Create BIOS boot partition:
```
Command (? for help): n
Partition number [...]: <Press enter to accept default>
First sector [...]: 2048
Last sector [...]: +2M
Hex code or GUID [...]: ef02
```
Create boot partition:
```
Command (? for help): n
Partition number [...]: <Press enter to accept default>
First sector [...]: <Press enter to accept default>
Last sector [...]: +500M
Hex code or GUID [...]: <Press enter to accept default>
```
Create main filesystem:
```
Command (? for help): n
Partition number [...]: <Press enter to accept default>
First sector [...]: <Press enter to accept default>
Last sector [...]: <Press enter to accept default>
Hex code or GUID [...]: <Press enter to accept default>
```
Save changes:
```
w
```

### 1.3 Prepare disk partitions for Arch installation
Create boot and root filesystems on corresponding partitions:
```
mkfs.ext4 -L fs_boot /dev/sda2
mkfs.ext4 -L fs_root /dev/sda3
```
Mount these filesystems:
```
mount /dev/sda3 /mnt
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
```

### 1.4 Install Arch Linux
Install Arch base, Linux kernel and firmware packages. Also install any text editor of your choice:
```
pacstrap /mnt base linux-zen linux-firmware nano
```

### 1.5 Basic system configuration
Save disk partitionins table:
```
genfstab -U /mnt >> /mnt/etc/fstab
```
Change root to new system:
```
arch-chroot /mnt
```
Set the timezone and syncronize it with hardware clock:
```
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc
```
Configure localization:
* Uncomment needed locales in `/etc/locale.gen`
* Create `/etc/locale.conf` and set `LANG` variables there:
```
LANG=en_US.UTF-8
```
List keyboard layouts and select one if needed:
```
ls /usr/share/kbd/keymaps/**/*.map.gz
loadkeys ru
```
Choose and set console font:
```
ls /usr/share/jbd/consolefonts
setfont <font>
```
Add chosen font and keyboard layout to `/etc/vconsole.conf`:
```
KEYMAP=ru
FONT=<font>
```
Create hostname file `/etc/hostname` that contains name of your machie:
```
archlinux
```
Add host aliases in `/etc/hosts`:
```
127.0.0.1       localhost
::1             localhost
127.0.1.1       <hostname>.localdomain   <hostname>
```
Set root password:
```
passwd
```

### 1.6 Install bootloader and other packages for convinience:
Install packages:
```bash
pacman -Syu \
    grub \                  # Bootloader
    networkmanager \        # Automatically connects to known networks
    base-devel \            # Some basic binaries such as file, gcc, gzip and other
    linux-zen-headers \     # Header files
    net-tools \             # Tools for managing network connections
    wireless_tools \        # Tools for managing wireless connections
    wpa_supplicant \        # Utility providing key negotiation for WPA wireless networks
    bluez \                 # Bluetooth manager
    bluez-utils \           # Utilities for bluetooth
    intel-ucode             # CPU microcode
```
Install grub on disk:
```
grub-install /dev/sda
```
Generate grub configuration files:
```
grub-mkconfig -o /boot/grub/grub.cfg
```
Enable bluetooth manage:
```
systemctl enable bluetooth
systemctl enable NetworkManager
```

### 1.7 Create new user with sudo privileges
Add new user to the system:
```
useradd -mG wheel leksus
```
Set password to this user:
```
passwd leksus
```
To give wheel group unlimited sudo permissions type `EDITOR=nano visudo` and uncomment following line:
```
%wheel ALL=(ALL:ALL) ALL
``` 

### 1.8 Booting into Arch Linux console
Exit chroot environment:
```
exit
```
Unmount mounted partitions:
```
umount -R /mnt
```
Reboot the machine

## 2. Setting up comfortable workspace
### 2.1 Installing software
...
