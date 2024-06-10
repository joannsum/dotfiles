{ inputs, ... }:
let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbBp2dH2X3dcU1zh+xW3ZsdYROKpJd3n13ssOP092qE jo@turingmachine"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBXTForyB6oNMK5bbGpALKU4lPsKRGxNLhrE/PnHHq7 shannan@bernie"
  ];
in
{
  users.users = {
    jo = {
      isNormalUser = true;
      home = "/home/jo";
      extraGroups = [
        "audio"
        "wheel"
        "docker"
        "plugdev"
        "vboxusers"
        "adbusers"
        "input"
        "kvm"
        "wireshark"
        "dialout"
      ];
      shell = "/run/current-system/sw/bin/zsh";
      uid = 1000;
      openssh.authorizedKeys.keys = keys;
    };
    root.openssh.authorizedKeys.keys = keys;
  };

  boot.initrd.network.ssh.authorizedKeys = keys;

  security.sudo.wheelNeedsPassword = false;

  imports = [
    ./zsh.nix
    inputs.clan-core.clanModules.root-password
  ];
}
