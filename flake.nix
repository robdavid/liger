{
  description = "A comprehensive Language Server Protocol (LSP) implementation for the Crystal programming language, designed to work cross-platform with a focus on Windows compatibility.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = {self, nixpkgs}:
  let
    version = builtins.head (builtins.match ".*\nversion: *([0-9.]+).*" (builtins.readFile ./shard.yml));
    supportedSystems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
        default = pkgs.crystal.buildCrystalPackage {
          pname = "liger";
          inherit version;
          src = self;
          # shardsFile = ./shards.nix;
          format = "shards";
          doCheck = false;
          doInstallCheck = false;
          buildInputs = with pkgs; [
            openssl
            pkg-config
            pcre
            ameba
            gmp
          ];
        };
      }
    );
  };

}
