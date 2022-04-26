{ config, lib, pkgs, isLinux, ... }:
let
  arch = if isLinux then "linux" else "darwin-10.9";
  version = "21.2.9";
  crdb = builtins.fetchTarball{
    url = "https://binaries.cockroachdb.com/cockroach-v${version}.${arch}-amd64.tgz";
  };
in
{
  config = {
    home.file."bin/cockroach".source = "${crdb}/cockroach";
  };
}
