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

      mkMarkdown = size: images:
        pkgs.writeText "images.md"
          (concatStringsSep "\n"
            (map (it: ''<img height="${toString size}" src="${baseNameOf it.image}"/>'') images));

      emojiMd = mkMarkdown 300 emoji;
      animeMd = mkMarkdown 700 anime;
    in
    {

      images = { inherit emoji anime; };

      packages.x86_64-linux.build-markdown = pkgs.writeScriptBin "build-markdown" ''
        cd $(git rev-parse --show-toplevel)
        cat ${emojiMd} > emoji/README.md
        cat ${animeMd} > anime/README.md
      '';


    };
}
