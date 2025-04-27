########################################################
#  __  __          __ _       _                _       #
# |  \/  |_   _   / _| | __ _| | _____   _ __ (_)_  __ #
# | |\/| | | | | | |_| |/ _` | |/ / _ \ | '_ \| \ \/ / #
# | |  | | |_| | |  _| | (_| |   <  __/_| | | | |>  <  #
# |_|  |_|\__, | |_| |_|\__,_|_|\_\___(_)_| |_|_/_/\_\ #
#         |___/                                        #
########################################################
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
