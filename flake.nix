{
  description = "My flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-packages = {
      url = "github:nsfisis/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      treefmt-nix,
      nur-packages,
      home-manager,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        formatter = treefmt.config.build.wrapper;
      }
    )
    // {
      homeConfigurations = (
        let
          readJSON = p: builtins.fromJSON (builtins.readFile p);
          mkHomeConfiguration =
            {
              name,
              profile,
              flake,
              ...
            }:
            home-manager.lib.homeManagerConfiguration rec {
              pkgs = import nixpkgs {
                system = flake.system;
                config.allowUnfree = true;
              };
              extraSpecialArgs = {
                nodeName = name;
                env = flake.env;
                nurpkgs = import nur-packages { inherit pkgs; };
              };
              modules = [
                ./home-manager/modules/common.nix
                ./home-manager/modules/${profile}.nix
              ];
            };
          mkHomeConfigurationFromJSON = p: mkHomeConfiguration (readJSON p);
        in
        {
          akashi = mkHomeConfigurationFromJSON ./mitamae/node.akashi.json;
          pc168 = mkHomeConfigurationFromJSON ./mitamae/node.pc168.json;
        }
      );
    };
}
