{
  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        test = pkgs.callPackage ./. { };
      in
      {
        packages = {
          inherit test;
          inherit (test) pdf no-pdf pdf-no-vm;
          default = test;
        };
      }
    );
}
