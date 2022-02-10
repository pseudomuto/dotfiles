{ config, lib, pkgs, ... }:
let
  crdb = builtins.fetchTarball{
    url = "https://binaries.cockroachdb.com/cockroach-v21.2.5.linux-amd64.tgz";
  };
in
{
  config = {
    home.file."bin/cockroach".source = "${crdb}/cockroach";
  };
}
