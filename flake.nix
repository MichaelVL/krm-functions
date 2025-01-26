{
  description = "Flake for krm-functions/catalog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            gnumake
            go_1_23
            golangci-lint
          ];
        };
        packages.default = self.packages.${system}.krm-package-compositor;
        packages.krm-package-compositor = pkgs.buildGoModule {
          pname = "krm-package-compositor";
          version = "0.1.0";
          src = ./.;
          subPackages = [ "cmd/package-compositor" ];
          vendorHash = "sha256-EoXw2eWuoUimlH1vCgE02CExvB48l0nMfJrU8dpe2Zs=";
          # vendorHash = nixpkgs.lib.fakeHash;
          buildInputs = [
            # ...
          ];
          postInstall = ''
            mv $out/bin/package-compositor $out/bin/krm-package-compositor
          '';
        };
      }
    );
}
