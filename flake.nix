{
  description = "FOSS Nix Memes";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;

  outputs = { self, nixpkgs }:
    let
      inherit (builtins) baseNameOf concatStringsSep;
      owners = import ./owners.nix;
      emoji = import ./emoji { inherit owners; };
      anime = import ./anime { inherit owners; };

      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      emojiImgs = map (it: ''<img style="max-height:300px" src="${baseNameOf it.image}"/>'') emoji;
      emojiMd = pkgs.writeText "emoji-readme.md" (concatStringsSep "\n" emojiImgs);
    in
    {

      images = { inherit emoji anime; };

      packages.x86_64-linux.build-markdown = pkgs.writeScriptBin "build-markdown" ''
        cat ${emojiMd} > emoji/README.md
      '';


    };
}
