{ pkgs, ... }:
{
  # touchpad identifies itself as DELL0A78:00 27C6:0D42 Touchpad in xinput list
  # it sometimes fails to register (ps2 mouse emulation works, but not scrolling)
  # hack around it by unloading and reloading module i2c_hid
  systemd.services.fix-touchpad = {
    path = [ pkgs.kmod ];
    serviceConfig.ExecStart = ''${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why="fixing touchpad must finish before sleep" --mode=delay ${./fix_touchpad.sh}'';
    serviceConfig.Type = "oneshot";
    description = "reload touchpad driver";
    # must run at boot (and not too early), and after suspend
    wantedBy = [
      "display-manager.service"
      "post-resume.target"
    ];
    # prevent running before suspend
    after = [ "post-resume.target" ];
  };

  # so that post-resume.service exists
  powerManagement.enable = true;
}
