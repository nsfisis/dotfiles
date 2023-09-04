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
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
  let
    mkHomeConfiguration = {
      system,
      env,
      ...
    }: home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit inputs;
        inherit env;
      };
      modules = [
        ./home-manager/home.nix
      ];
    };
  in {
    homeConfigurations = {
      privateHotaru = mkHomeConfiguration {
        system = "x86_64-linux";
        env = {
          username = "ken";
          homeDirectory = "/home/ken";
          gui.clipboard.copyCommand = null;
        };
      };
    };
  };
}
