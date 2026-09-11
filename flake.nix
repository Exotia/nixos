{
  description = "Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, nixos-apple-silicon, home-manager, ... }: {
    nixosConfigurations.oso-air = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./configuration.nix
        nixos-apple-silicon.nixosModules.apple-silicon-support
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.oso = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
