<!-- Output copied to clipboard! -->

<!-----

Yay, no errors, warnings, or alerts!

Conversion time: 0.321 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β33
* Sun Nov 20 2022 12:13:23 GMT-0800 (PST)
* Source doc: bath.cackalacky.cafe installation steps
----->


Following [https://nixos.org/manual/nixos/stable/index.html#sec-installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation)

Installing onto 500GB NVME - reserving 1TB NVME for data.


## Install from USB stick

export DISK=/dev/nvme1n1

parted $DISK -- mklabel gpt

parted $DISK -- mkpart primary 512MB -64GB

parted $DISK -- mkpart primary linux-swap -64GB 100%

parted $DISK -- mkpart ESP fat32 1MB 512MB

parted $DISK -- set 3 esp on

mkfs.ext4 -L nixos ${DISK}p1

mkswap -L swap ${DISK}p2

mkfs.fat -F 32 -n boot ${DISK}p3

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot

mount /dev/disk/by-label/boot /mnt/boot

swapon ${DISK}p2

nixos-generate-config --root /mnt

nixos-install

reboot


## Enable SSH

nano /etc/nixos/configuration.nix

uncomment:

services.openssh.enable = true;

add (ensure it has a trailing semicolon!)

services.openssh.passwordAuthentication = true;

apply changes:

nixos-rebuild switch


## Upgrading NixOS

sudo  nix-channel --add https://nixos.org/channels/nixos-22.05 nixos

sudo nixos-rebuild switch --upgrade


## Create Mastodon Pool

doas sgdisk --zap-all /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227

doas zpool create -f mastodon  /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A


### Previous ZFS install error for posterity:

updating GRUB 2 menu...

mount: /boot/efis/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A-part1: /dev/nvme0n1p1 already mounted on /boot/efis/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A-part1.

installing the GRUB 2 boot loader on /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A...

Installing for i386-pc platform.

/nix/store/62yjzcx6b94zw8x6vzhswwfmlpa3gvsx-grub-2.06/sbin/grub-install: warning: this GPT partition label contains no BIOS Boot Partition; embedding won't be possible.

/nix/store/62yjzcx6b94zw8x6vzhswwfmlpa3gvsx-grub-2.06/sbin/grub-install: error: filesystem `zfs' doesn't support blocklists.

/nix/store/3ph12axm2zqcmp9qrqkfvdgv5jnnsk64-install-grub.pl: installation of GRUB on /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A failed: No such file or directory
