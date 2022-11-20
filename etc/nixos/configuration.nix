# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "bath";

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # used for maintenance tasks (un-elevated)
  users.users.barista = {
     isNormalUser = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim
     git
  ];
  environment.variables.EDITOR = "nvim";


  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
      extraPackages = [ pkgs.zfs ];
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

