{
  description = "NixOS + Home Manager configuration for oso's machines";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Board support for the Raspberry Pi and friends
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apple Silicon (Asahi) kernel, firmware and GPU support for the M2 Air
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nixos-apple-silicon, home-manager, ... }:
    let
      # One machine.
      #
      # `name` has to match three things at once: the directory hosts/<name>,
      # the Home Manager profile home/profiles/<name>.nix, and the machine's
      # actual hostname. That last one is what lets the `nrs` alias figure out
      # which configuration to build without being told.
      mkHost = { name, system ? "aarch64-linux", modules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          # Board-support modules go directly after the host, before Home
          # Manager. NixOS merges list-valued options in module order, so
          # moving them changes generated files even when nothing else does.
          modules = [
            ./modules/common.nix
            (./hosts + "/${name}")
          ] ++ modules ++ [
            home-manager.nixosModules.home-manager
            {
              networking.hostName = name;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.oso = import (./home/profiles + "/${name}.nix");
                backupFileExtension = "backup";
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # MacBook Air M2, Asahi
        oso-air = mkHost {
          name = "oso-air";
          modules = [ nixos-apple-silicon.nixosModules.apple-silicon-support ];
        };

        # Raspberry Pi 4
        oso-pi = mkHost {
          name = "oso-pi";
          modules = [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        };
      };
    };
}
