{
  description = "FOSS Nix Memes";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable-small;

  outputs = { self, nixpkgs }:
    let
      inherit (builtins) baseNameOf concatStringsSep;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      args = { creators = import ./creators.nix; };

      mkMarkdown = height: images:
        pkgs.writeText "images.md"
          (concatStringsSep "\n"
            (map (it: ''<img height="${toString height}" src="${baseNameOf it.image}"/>'') images));
    in {

      packages.x86_64-linux = rec {
        emojiMd = mkMarkdown 300 (import ./emoji args);
        animeMd = mkMarkdown 700 (import ./anime args);
        memesMd = mkMarkdown 700 (import ./memes args);

        build-markdown = pkgs.writeScriptBin "build-markdown" ''
          cd $(git rev-parse --show-toplevel)
          cat ${emojiMd} > emoji/README.md
          cat ${animeMd} > anime/README.md
          cat ${memesMd} > memes/README.md
        '';
      };

    };
}
