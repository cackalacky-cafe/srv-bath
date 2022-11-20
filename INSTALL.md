Following [https://nixos.org/manual/nixos/stable/index.html#sec-installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation)

Installing onto 500GB NVME - reserving 1TB NVME for data.

## Install from USB stick

```shell
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
```

## Enable SSH

```
nano /etc/nixos/configuration.nix
```

uncomment:

```
services.openssh.enable = true;
```

add (ensure it has a trailing semicolon!)

```
services.openssh.passwordAuthentication = true;
```

apply changes:

```
nixos-rebuild switch
```

## Upgrading NixOS

```shell
sudo nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
sudo nixos-rebuild switch --upgrade
'''

## Create Mastodon Pool

```shell
doas sgdisk --zap-all /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227
doas zpool create -f mastodon  /dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4P4NF0M539227A
```

