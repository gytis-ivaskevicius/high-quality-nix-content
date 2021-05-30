{
  description = "FOSS Nix Memes";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;

  outputs = { self, nixpkgs }:
    let
      owners = import ./owners.nix;
      emoji = import ./emoji { inherit owners; };
      anime = import ./anime { inherit owners; };
    in
    {

      nixosModules = { inherit emoji anime; };

    };
}
