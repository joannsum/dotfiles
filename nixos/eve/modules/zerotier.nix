{
  imports = [ ../../modules/zerotier.nix ];

  clan.networking.zerotier.controller.enable = true;
  clan.networking.zerotier.moon.stableEndpoints = [
    "95.217.199.121"
    "2a01:4f9:4a:42e8::1"
  ];
}
