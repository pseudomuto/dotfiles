{ config, lib, pkgs, ... }:
let
  homeDir = builtins.getEnv "HOME";
  user = builtins.getEnv "USER";

  # pull down kube-ps1 for setting the prompt
  # Update with values from: nr nix-prefetch-github jonmosco kube-ps1
  kubeps1 = pkgs.fetchFromGitHub {
    owner = "jonmosco";
    repo = "kube-ps1";
    rev = "dd367e49f8040d970be83dca07d9d889ca1ab3fb";
    sha256 = "6iP4+IDjhCu5YWkrUF8U34HWa/K3EB5QnTr+M9kUdq4=";
  };
in
{
  config = {
    home.file.".bash_profile".source = ../files/.bash_profile;
    home.file.".bashrc".source = ../files/.bashrc;
    home.file.".config/shell/aliases".source = ../files/shell/aliases;
    home.file.".config/shell/exports".source = ../files/shell/exports;
    home.file.".config/shell/rc".source = ../files/shell/rc;
    home.file.".config/shell/completions/k8s.bash".source = ../files/shell/completions/k8s.bash;

    programs.zsh = {
      enable = true;
      initExtra = ''
        unsetopt nomatch
        export SHELL="zsh"
        export KUBE_PS1_SYMBOL_DEFAULT="kube"
        source "${kubeps1}/kube-ps1.sh"
        source "${homeDir}/.config/shell/rc"
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "fasd"
          "git"
          "gitfast"
          "history-substring-search"
        ];
        theme = "robbyrussell";
      };
    };

    home.activation.setDefaultShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD sudo chsh -s "${pkgs.zsh}/bin/zsh" "${user}"
    '';
  };
}
