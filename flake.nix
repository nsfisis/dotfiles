{
  description = "My flake configuration";

  inputs = {
    # TODO
    # nixpkgs#deno in nixpkgs-unstable branch is broken for now.
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/1b36b17a09686ff51e2944334da1cf308fa81e48";

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
              system,
              env,
              ...
            }:
            home-manager.lib.homeManagerConfiguration {
              pkgs = import nixpkgs { inherit system; };
              extraSpecialArgs = {
                inherit env;
                nurpkgs = nur-packages.legacyPackages.${system};
              };
              modules = [
                ./home-manager/home.nix
              ];
            };
          mkHomeConfigurationFromJSON = p: mkHomeConfiguration (readJSON p).flake;
        in
        {
          akashi = mkHomeConfigurationFromJSON ./mitamae/node.akashi.json;
          pc168 = mkHomeConfigurationFromJSON ./mitamae/node.pc168.json;
        }
      );
    };
}
