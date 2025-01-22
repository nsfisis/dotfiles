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

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      home-manager,
      ...
    }:
    let
      eachDefaultSystem =
        f:
        flake-utils.lib.eachDefaultSystem (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          }
        );
    in
    eachDefaultSystem (
      { system, pkgs }:
      {
        formatter = pkgs.nixfmt-rfc-style;
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
              extraSpecialArgs = { inherit env; };
              modules = [
                ./home-manager/home.nix
              ];
            };
          mkHomeConfigurationFromJSON = p: mkHomeConfiguration (readJSON p).flake;
        in
        {
          akashi = mkHomeConfigurationFromJSON ./mitamae/node.akashi.json;
          hotaru = mkHomeConfigurationFromJSON ./mitamae/node.hotaru.json;
          pc168 = mkHomeConfigurationFromJSON ./mitamae/node.pc168.json;
        }
      );
    };
}
