{ pkgs, config, ... }:
{
  services.phpfpm.pools.adminer = {
    user = "adminer";
    group = "adminer";
    settings = {
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "pm" = "ondemand";
      "pm.max_children" = 32;
      "pm.process_idle_timeout" = "10s";
      "pm.max_requests" = 500;
    };
  };

  services.nginx = {
    virtualHosts."adminer.thalheim.io" = {
      useACMEHost = "thalheim.io";
      forceSSL = true;
      extraConfig = ''
        index adminer.php;
      '';
      locations."/".extraConfig = ''
        try_files $uri $uri/ /index.php?$args;
      '';
      locations."~* ^.+\.php$".extraConfig = ''
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_pass unix:${config.services.phpfpm.pools.adminer.socket};
        fastcgi_index adminer.php;
        fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
      '';
      root = "${pkgs.adminer}";
    };
  };

  users.users.adminer = {
    isSystemUser = true;
    createHome = true;
    group = "adminer";
  };

  users.groups.adminer = {};
  services.netdata.httpcheck.checks.adminer = {
    url = "https://adminer.thalheim.io";
    regex = "Login";
  };

  services.icinga2.extraConfig = ''
    apply Service "Adminer v4 (eve)" {
      import "eve-http4-service"
      vars.http_vhost = "adminer.thalheim.io"
      vars.http_uri = "/"
      assign where host.name == "eve.thalheim.io"
    }

    apply Service "Adminer v6 (eve)" {
      import "eve-http6-service"
      vars.http_vhost = "adminer.thalheim.io"
      vars.http_uri = "/"
      assign where host.name == "eve.thalheim.io"
    }
  '';
}
