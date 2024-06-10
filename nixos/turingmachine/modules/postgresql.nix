{ ... }:
{
  services.postgresql.enable = true;
  services.postgresql.ensureDatabases = [ "jo" ];
  services.postgresql.ensureUsers = [
    {
      name = "jo";
      ensureDBOwnership = true;
    }
  ];
}
