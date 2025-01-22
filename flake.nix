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

  outputs = {
    nixpkgs,
    flake-utils,
    home-manager,
    ...
  }:
  let
    readJSON = p: builtins.fromJSON (builtins.readFile p);
    machines = [
      (readJSON ./mitamae/node.akashi.json)
      (readJSON ./mitamae/node.hotaru.json)
      (readJSON ./mitamae/node.pc168.json)
    ];
    mkHomeConfiguration = {
      system,
      env,
      ...
    }: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit env; };
      modules = [
        ./home-manager/home.nix
      ];
    };
  in {
    homeConfigurations = (
      builtins.listToAttrs (
        builtins.map (machine: {
          name = machine.name;
          value = mkHomeConfiguration machine.flake;
        })
        machines
      )
    );
  };
}
