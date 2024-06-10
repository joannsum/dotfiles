{ config, pkgs, ... }:
{
  imports = [ ../../modules/xrdp.nix ];
  environment.systemPackages = [
    pkgs.jetbrains.idea-ultimate
    pkgs.firefox
  ];

  sops.secrets.xrdp-password.neededForUsers = true;
  users.users.jo.passwordFile = config.sops.secrets.xrdp-password.path;
}
