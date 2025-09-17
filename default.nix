{
  mdbook,
  mdbook-pdf,
  ungoogled-chromium,
  stdenvNoCC,
  vmTools,
  fontconfig,
}:
let
  mkBook =
    {
      pdf ? true,
      vm ? pdf,
    }:
    let
      drv = stdenvNoCC.mkDerivation {
        name = "mdbook-pdf-test";
        nativeBuildInputs = [
          mdbook
          mdbook-pdf
          ungoogled-chromium
        ];
        passthru = {
          pdf = mkBook { pdf = true; };
          no-pdf = mkBook { pdf = false; };
          pdf-no-vm = mkBook {
            pdf = true;
            vm = false;
          };
        };
        src = ./src;
        unpackPhase = ''
          mkdir -p src
          cp $src/* src -r
        '';
        configurePhase = ''
          mv src/book-${if pdf then "pdf" else "html"}.toml book.toml
          export FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf"
        '';
        buildPhase = ''
          mdbook build -d $out
        '';
      };
    in
    if vm then vmTools.runInLinuxVM drv else drv;
in
mkBook { }
