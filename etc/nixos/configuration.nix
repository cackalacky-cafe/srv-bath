# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./zfs.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];

  system.autoUpgrade.enable = true;

  networking.hostName = "bath";
  time.timeZone = "America/New_York";

  users.users.t = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDce/caLihdEi7gbMumkwnaA8N/GjLEUvEXib6CldmMvxQJIVr8lU+2608DrW91GTixrNimhdZTIh0MEqdnmPs7rmMzUH1ErSU/ghggOSbyEMaAo7Rvg+eEMYpmjtM06JKNJB0bOKR8PwqkQZXrYnGaIDUu46PhKkqvSx09zP3zFohptDCX7rJhdLTnrzmyKxDUDmXuzgyDa7dE7FFAa0sx5pyc9sxY0PcJ+dTK+4cWKyN2CKmdJoqdbsuRSNwyqGkiOVTDYIEQAN0dAa1yBOE9IHh+J4E183ClAAAOJ2oQdFUhw7Zzlj2tey7nJ256YHsUW3Vi+lZpebQpmcX4IVLHKVtoRP1wXMsVOnO1141S1NsGJci4HrAhNmJ/7/WkdmnbbklPhCQC5JxTns/vgpdR35JU3jq/aILGckqxOsJuMLUvbMjcDSsC0b/wSsiT9XQ0biR4f0XdDPww2Xf1wUtx5fLggfh0I8LCACAJ3A5vSJT1n0W/2sXanSb11FIWRlM= t@bambu.local"
     ];
  };

  users.users.rebelopsio = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIAdTjbX78GOtDCMqhbAZ1G/+xYo5du5Mb2du62tFv2fEB80iDGS2HgzqCeRUpDxUYbYTz/ahikNv46IbNoNAB2zxtDyU3SDwDhunBLhTtQ+WMOo3J6K2+gVUNxwJAx2NSvWNppXrYYbHBAdBgRxNcoi1GSqnKXGcjjJzaTsyEGUYHxJabBh3OxoYGSAJuX7crGFP8WQ3QX2j+JwjqfmJX0KoBWxudQm1MgivXbKjaiUNK5MADueEOtI7r5dhDL92wlt/D1cbT5DxHR8/wOJCXB5oEJzs3pxf9qNdmM8U87E6L8BWXCmJWx5FehmEVLcDgWo4lo1zDTSecSk4P/oY6+JyuzLZMDl7GWY95Umaaw4P6YccES27y2dKxi+ku2NQTCJhyTBy/uUduX9M+pwfFyui/WuyeXKnBgh9M0yjWXInG2yYNnZAG8kj8C3o3D/4lNLjfPbM/EnYHeIoDkesuVU1HPkzsyU9rWSWZd2FHDYHoB/j4HUeWcD2NDjbEgbc="
     ];
  };

  users.users.barista = {
     isNormalUser = true;
  };

  users.users.postgres = {
     isSystemUser = true;
     group = "postgres";
     uid = 70;
  };
  users.groups.postgres = {};

  users.users.redis = {
     isSystemUser = true;
     group = "redis";
  };
  users.groups.redis = {};

  users.users.elasticsearch = {
     isNormalUser = true;
     group = "elasticsearch";
  };
  users.groups.elasticsearch = {};

  users.users.mastodon = {
     isSystemUser = true;
     group = "mastodon";
  };
  users.groups.mastodon = {};

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/15 * * * *      barista	/home/barista/src/commit-etc/commit-etc.sh"
    ];
  };


  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
	groups = [ "wheel" ];
	keepEnv = true;
	persist = true;
  }];

  environment.systemPackages = with pkgs; [
     conmon
     postgresql
     neovim
     tmux
     git
     gptfdisk
     podman-compose
  ];
  environment.variables.EDITOR = "nvim";

  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
      extraPackages = [ pkgs.zfs ];
    };
  };
  # allow dnsname to work on all networks
  # virtualisation.containers.containersConf.cniPlugins = [ pkgs.cni-plugins pkgs.dnsname-cni ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "yes";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.copySystemConfiguration = true;
  system.stateVersion = "22.05"; # Did you read the comment?

  boot.kernel.sysctl = {
    "vm.max_map_count" = 512000;
    # Requested by Redis
    "vm.overcommit_memory" = 1;
  };

  fileSystems."/mastodon" = {
    device = "mastodon";
    fsType = "zfs";
  };

  fileSystems."/mastodon/es" = {
    device = "mastodon/es";
    fsType = "zfs";
  };

  fileSystems."/mastodon/redis" = {
    device = "mastodon/redis";
    fsType = "zfs";
  };
  
  fileSystems."/mastodon/postgres" = {
    device = "mastodon/postgres";
    fsType = "zfs";
  };
  
  fileSystems."/mastodon/public" = {
    device = "mastodon/public";
    fsType = "zfs";
  };
}

