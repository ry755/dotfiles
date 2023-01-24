# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use systemd-boot.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Use the latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable NTFS support.
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking.
  networking.hostName = "fox-tower";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable nvidia drivers.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;  

  # Enable dwm.
  services.xserver.windowManager.dwm.enable = true;

  # Configure dwm.
  nixpkgs.overlays = [
  (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
      patches = [
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/autostart/dwm-autostart-20210120-cb3f58a.diff";
          sha256 = "1gksmq7ad3fs25afgj8irbwcidhyzh0cmba7vkjlsmbdgrc131yp";
        })
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/pertag/dwm-pertag-20200914-61bb8b2.diff";
          sha256 = "1lbzjr972s42x8b9j6jx82953jxjjd8qna66x5vywaibglw4pkq1";
        })
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/fancybar/dwm-fancybar-20220527-d3f93c7.diff";
          sha256 = "1q4318676aavvx7kiwqab4wzaq5y7b1n90cskpdgx1v3nvkq4s4x";
        })
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff";
          sha256 = "0qymdjh7b2smbv37nrh0ifk7snm07y4hhw7yiizh6kp2kik46392";
        })
      ];
      configFile = super.writeText "config.h" (builtins.readFile ./dwm-config.h);
      postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
    });
  })];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ry = {
    isNormalUser = true;
    description = "Ry";
    extraGroups = [
      "wheel"
      "dialout"
      "networkmanager"
      "kvm"
      "vboxusers"
    ];
  };

  # Enable and configure zsh.
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  # Set default shell to zsh.
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # chat
    discord
    noisetorch
    pulseaudio # installed but not enabled

    # development
    binutils
    cmake
    distrobox
    gcc
    gimp
    git
    gnumake
    kate
    kicad
    luajit
    minipro
    neovim
    python3
    rustup
    sdcc
    SDL2
    SDL2.dev
    vim
    vscode.fhs
    wget

    # games
    prismlauncher

    # tools
    pavucontrol

    # web
    firefox

    # window manager stuff
    alacritty
    cinnamon.nemo
    compton
    dmenu
    dunst
    feh
    i3lock
    pamixer
    xss-lock
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "22.11"; # Did you read the comment?

}
