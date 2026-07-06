{
  description = "ESP32 WROOM bare-metal Zig dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system:
          f {
            pkgs = import nixpkgs { inherit system; };
          });
    in
    {
      packages = forAllSystems ({ pkgs }:
        let
          zig-xtensa = pkgs.stdenvNoCC.mkDerivation {
            pname = "zig-xtensa";
            version = "0.16.0-xtensa";

            src = pkgs.fetchurl {
              url = "https://github.com/kassane/zig-espressif-bootstrap/releases/download/0.16.0-xtensa/zig-relsafe-x86_64-linux-musl-baseline.tar.xz";
              hash = "sha256-nj3O+db21VLfZBoSrdyeRDppt8va2FSS7Gd6zVW33ps=";
            };

            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r . $out/

              mkdir -p $out/bin
              chmod +x $out/zig
              ln -s $out/zig $out/bin/zig

              runHook postInstall
            '';
          };
        in
        {
          default = zig-xtensa;
          inherit zig-xtensa;
        });

      devShells = forAllSystems ({ pkgs }:
        let
          zig-xtensa = self.packages.${pkgs.system}.zig-xtensa;
        in
        {
          default = pkgs.mkShell {
            packages = [
              zig-xtensa
              pkgs.esptool
              pkgs.git
              pkgs.gnumake
              pkgs.cmake
              pkgs.ninja
              pkgs.picocom
            ];

            shellHook = ''
              echo "ESP32 Xtensa Zig shell"
              echo "zig build -Dtarget=xtensa-freestanding-none -Dcpu=esp32 --release=small"
            '';
          };
        });
    };
}