{
  description = "FOSS Nix Memes";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;

  outputs = { self, nixpkgs }:
    let
      inherit (builtins) baseNameOf concatStringsSep;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      args = { creators = import ./creators.nix; };

      emoji = import ./emoji args;
      anime = import ./anime args;
      memes = import ./memes args;

      mkMarkdown = size: images:
        pkgs.writeText "images.md"
          (concatStringsSep "\n"
            (map (it: ''<img height="${toString size}" src="${baseNameOf it.image}"/>'') images));

      emojiMd = mkMarkdown 300 emoji;
      animeMd = mkMarkdown 700 anime;
      memesMd = mkMarkdown 700 memes;
    in
    {

      images = { inherit emoji anime; };

      packages.x86_64-linux.build-markdown = pkgs.writeScriptBin "build-markdown" ''
        cd $(git rev-parse --show-toplevel)
        cat ${emojiMd} > emoji/README.md
        cat ${animeMd} > anime/README.md
        cat ${memesMd} > memes/README.md
      '';


    };
}
