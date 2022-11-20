{ config, pkgs, ... }:

{ boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "38c9101a";
}
