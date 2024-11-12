# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, host, username, options, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./users.nix
    ];
  # enable the Flakes feature and the accompanying new nix command-line tool
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;

    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  }; 

  boot = {
    plymouth.enable = true;
    # Bootloader
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make audio able to work (hopefully)
    kernelParams = ["snd-intel-dspcfg.dsp_driver=1"];
    kernelPackages = pkgs.linuxPackages_zen;
    extraModprobeConfig = ''
      options snd-intel-dspcfg dsp_driver=1
    '';
  };

  networking.hostName = host; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    # General UI stuff with gnome
    xserver = {
      dpi = 96;
      enable = true;
      #desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;  
      };
    # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
    # Blueman program for bluetooth
    blueman.enable = true;

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = false;
      wireplumber = {
        enable = true;
        # Trying to improve bluetooth sound
        # See https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/bluetooth.html#monitor-properties 
        # for more information
        #extraConfig = {
        #  "monitor.bluez.properties" = {
        #    "bluez5.enable-sbc-xq" = true;
        #    "bluez5.enable-msbc" = true;
        #    "bluez5.enable-hw-volume" = true;
        #    "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
        #  };
        #  "monitor.alsa" = {
        #    "enabled" = true;
        #    "rules" = [ {
        #        "matches" = [ { "node.name" = "~alsa_output.*"; } ];
        #        "actions" = { "update-props" = { "session.suspend-timeout-seconds" = 0; }; }; }
        #    ];
        #  };
        #};
      };  
    };

    
  };

  hardware = {
    # Disable pulseaudio so Pipewire can work
    pulseaudio.enable = false;

    # Bluetooth Support
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    firmware = with pkgs; [
      sof-firmware
    ];
    # Hopefully get some audio drivers, not sure if anything else really needs it
    enableAllFirmware = true;  
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;
  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-xapp
      ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  # Install firefox.
  programs = {
    firefox.enable = true; 
    steam = {
      enable = true; 
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };     
    dconf.enable = true;
    gamemode.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    sof-firmware
    htop
    inxi
    steam-tui
    steamcmd
    alsa-utils
    alsa-ucm-conf
    xorg.xdpyinfo
  ];

  environment.variables = {
    QT_SCALE_FACTOR = "2";
    NIXOS_OZONE_WL = "1";
    STEAM_FORCE_DESKTOPUI_SCALING = "2.0";
  };
  # default styling with stylix
  stylix = {
    enable = true;
    image = ./wallpaper.jpg;
    cursor = {
      size = 24;
      package = pkgs.bibata-cursors;
      name =  "Bibata-Modern-Ice";
    };
    fonts = {
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

