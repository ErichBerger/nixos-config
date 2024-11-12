{ config, pkgs, username, host, ... }:

{
  home = {
    # Set name and home directory
    username = "${username}";
    homeDirectory = "/home/${username}";
    # Set version of home manager
    stateVersion = "24.05";
    packages = with pkgs; [
      nmap
      cowsay  
      zoom-us
      spotify
      pavucontrol
      gh
      
    ];

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    dataHome = "${config.home.homeDirectory}/.local/share";
    configHome = "${config.home.homeDirectory}/.config";
    stateHome = "${config.home.homeDirectory}/.local/state";
    cacheHome = "${config.home.homeDirectory}/.cache";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
    systemd.variables = [ "--all"];
  };
  # Define packages to be used within home

  programs = {
    # Let Home Manager install and manage itself
    home-manager.enable = true;

    # basic configuration of git
    git = {
      enable = true;
      userName = "ErichBerger";
      userEmail = "erichcberger@gmail.com";
    };

    # Kitty 
    kitty.enable = true;
    # Special bash commands
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';
      shellAliases = {
        home = "sudoedit /etc/nixos/home.nix";
        config = "sudoedit /etc/nixos/configuration.nix";
      };
    };
    # Helix editor TODO: Make changes to languages for support
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "nord";
        editor = {
          line-number = "relative";
          cursor-shape = {
            insert = "bar";
            normal = "block";
          };
        };
      };
    };
  };

  stylix = {
    targets = {
      helix.enable = false; 
    };
  };

  gtk = {
    enable = true;

    
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };

}
