{
  virtualisation.libvirtd.enable = true;
  users.users.jo.extraGroups = [ "libvirtd" ];
  networking.firewall.checkReversePath = false;
  programs.virt-manager.enable = true;
}
