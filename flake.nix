{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      pre-commit-hooks,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              ensure_bcc_version = {
                enable = true;
                name = "set correct version in bcc";
                entry = ''${pkgs.lib.getExe pkgs.sd} 'modpackVersion = ".*?"' 'modpackVersion = "${(builtins.fromTOML (builtins.readFile ./pack.toml)).version}"' content/config/bcc-common.toml'';
                pass_filenames = false;
                files = "pack.toml";
              };
              packwiz-refresh = {
                enable = true;
                name = "Packwiz refresh";
                entry = "${pkgs.lib.getExe pkgs.packwiz} refresh";
                pass_filenames = false;
              };
              replace-server-with-both = {
                enable = true;
                name = ''Replace "server" side with "both", as server is always wrong'';
                entry = ''${pkgs.lib.getExe pkgs.sd} 'side = "server"' 'side = "both"' '';
                files = ''\.pw\.toml$'';
              };
            };
          };
        };

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;

          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;

          packages = [
            pkgs.packwiz
            pkgs.taplo
            pkgs.vscode-langservers-extracted
            pkgs.sd
            pkgs.nodejs
            pkgs.act
          ];
        };
      }
    );
}
