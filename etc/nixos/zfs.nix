{ config, pkgs, ... }:

{ boot.supportedFilesystems = [ "zfs" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.zfs.extraPools = [ "mastodon" ];
  networking.hostId = "38c9101a";

  #services.zfs.trim.enable = true;
  #services.zfs.autoScrub.enable = true;
}
