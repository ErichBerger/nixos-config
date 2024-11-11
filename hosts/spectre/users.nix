
{
  pkgs, username, ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      
      isNormalUser = true;
      description = "Erich Berger";
      extraGroups = [ 
        "networkmanager" 
        "wheel" 
        "audio" 
        "sound" 
        "video"
      ];
      packages = with pkgs; [ ];
      shell = pkgs.bash;
    };
  };
}
