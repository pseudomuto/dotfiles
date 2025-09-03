{
  description = "Cross-platform dotfiles management with Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Helper to create Home Manager configuration
      mkHomeConfiguration =
        {
          system,
          modules,
          username,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = modules ++ [
            {
              home = {
                inherit username;
                homeDirectory =
                  if nixpkgs.lib.hasInfix "darwin" system then "/Users/${username}" else "/home/${username}";
                stateVersion = "25.05";
              };
            }
          ];
        };
    in
    {
      # Home Manager configurations
      homeConfigurations =
        let
          # Get current USER, fallback to nixuser for containers
          currentUser = if (builtins.getEnv "USER") != "" then (builtins.getEnv "USER") else "pseudomuto";
        in
        {
          # Darwin configuration
          "pseudomuto@darwin" = mkHomeConfiguration {
            system = "aarch64-darwin";
            username = currentUser;
            modules = [
              ./systems/darwin.nix
              ./modules
            ];
          };

          # Linux configurations with explicit nixuser for containers
          "pseudomuto@linux-aarch64" = mkHomeConfiguration {
            system = "aarch64-linux";
            username = "nixuser";
            modules = [
              ./systems/linux.nix
              ./modules
            ];
          };

          # Also provide current user Linux configs if different from nixuser
        }
        // (
          if currentUser != "nixuser" then
            {
              "${currentUser}@linux-aarch64" = mkHomeConfiguration {
                system = "aarch64-linux";
                username = currentUser;
                modules = [
                  ./systems/linux.nix
                  ./modules
                ];
              };

              "${currentUser}@linux-x86_64" = mkHomeConfiguration {
                system = "x86_64-linux";
                username = currentUser;
                modules = [
                  ./systems/linux.nix
                  ./modules
                ];
              };
            }
          else
            { }
        );

      # Development shells for each system
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
            ];

            shellHook = ''
              echo "Dotfiles development environment"
              echo "System: ${system}"
              echo ""
              echo "Available commands:"
              echo "  ./apply     - Apply Home Manager configuration"
              echo "  nix flake check - Check flake configuration"
              echo "  nix flake update - Update flake inputs"
            '';
          };
        }
      );

      # Packages that can be built
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          apply-script = pkgs.writeScriptBin "apply" (builtins.readFile ./apply);
        }
      );
    };
}
