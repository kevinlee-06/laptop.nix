{ config, pkgs, lib, ... }:

# Nix Software Center
let
  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) {};
in
{
  # Hardware config
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./zerotier.nix
    ./sleep.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };
  };

  # Time & Locale & Input method
  time.timeZone = "Asia/Taipei";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_TW.UTF-8";
      LC_IDENTIFICATION = "zh_TW.UTF-8";
      LC_MEASUREMENT = "zh_TW.UTF-8";
      LC_MONETARY = "zh_TW.UTF-8";
      LC_NAME = "zh_TW.UTF-8";
      LC_NUMERIC = "zh_TW.UTF-8";
      LC_PAPER = "zh_TW.UTF-8";
      LC_TELEPHONE = "zh_TW.UTF-8";
      LC_TIME = "zh_TW.UTF-8";
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_TW.UTF-8/UTF-8"
    ];
    inputMethod = {
      enabled = "fcitx5";
      # type = "fcitx5";
      # enable = true;
      # waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons 
        fcitx5-nord
        fcitx5-chewing
     ];
    };
  };

  # Desktop
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # CUPS
  services.printing.enable = true;
  
  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Users
  users.users.kevin = {
    isNormalUser = true;
    description = "kevin";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    packages = with pkgs; [
      thunderbird
      vscode
      vesktop
      localsend
      remmina
      brave
      vlc
      scrcpy
      lshw
    ];
  };

  # Firefox
  programs.firefox.enable = true;
  
  # Repo
  nixpkgs.config.allowUnfree = true;
  
  # Flatpak
  services.flatpak.enable = true;

  # VMM
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # SSH
  services.openssh.enable = true;
  
  # ADB
  programs.adb.enable = true;

  # Packages
  environment.systemPackages = (with pkgs; [
      btop
      cava
      curl
      distrobox
      git
      gparted
      gnome-themes-extra
      gtk-engine-murrine
      htop
      qemu
      sassc
      virt-manager
      neovim
      neofetch
      nix-software-center
      unimatrix
      vim
      wget
      python313Full
      go
      nodejs_22
      glxinfo
      mesa
      gcc
      rustc
      rustup
      tmux
      gnome.gnome-tweaks
      gnome-extension-manager
      linux-firmware
      pciutils
      waypipe
      ffmpeg
    ] ++ [
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.kimpanel
      # gnomeExtensions.tilling-shell
      gnomeExtensions.vertical-workspaces
    ]);
  
  services.power-profiles-daemon.enable = true;

  # Font packages
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      ubuntu_font_family
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];

    # Display fonts
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Sans CJK TC" "DejaVu Sans" "Liberation Serif" "Vazirmatn" ];
        sansSerif = [ "Noto Sans CJK TC" "Ubuntu" "Noto Sans" ];
        monospace = [ "Source Code Pro" "Ubuntu Mono" ];
      };
    };
  };

  environment.variables.EDITOR = "vim";
 # Docker
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = false;
    };
    docker = {
      enable = true;
      rootless = {
          enable = true;
          setSocketVariable = true;
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
