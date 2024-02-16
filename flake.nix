{
  description = "redwood is a ruby wrapper for the cedar policy language.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , pre-commit-hooks
    , naersk
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk { };

        mkRedwood = args:
          let
            defaultArgs = {
              src = ./.;

              cargoTestCommands = prev:
                prev
                ++ [
                  ''cargo $cargo_options clippy -Dwarnings''
                ];

              override = prev: prev // { nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.clippy ]; };
            };
          in
          naersk'.buildPackage (defaultArgs // args);

        preCommitHook = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            nixpkgs-fmt.enable = true;
            rustfmt.enable = true;
          };
        };
      in
      {
        packages = rec {
          redwood = mkRedwood { };

          default = redwood;
        };

        devShells.default = pkgs.mkShell {
          shellHook = ''
            ${preCommitHook.shellHook}
          '';

          nativeBuildInputs = with pkgs; [
            rustc
            cargo

            clippy
            rust-analyzer
            rustfmt
          ];
        };

        formatter = pkgs.nixpkgs-fmt;

        checks = {
          redwood = mkRedwood { doCheck = true; };
          pre-commit = preCommitHook;
        };
      }
    );
}
